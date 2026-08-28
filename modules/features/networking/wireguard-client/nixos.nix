{
  config,
  hostName,
  lib,
  pkgs,
  ...
}:

let
  secretsRoot = ../../../../secrets;
  encryptedTunnelDirectory = secretsRoot + "/wireguard-client/${hostName}";
  directoryEntries =
    if builtins.pathExists encryptedTunnelDirectory then
      builtins.readDir encryptedTunnelDirectory
    else
      { };
  tunnelFileNames = builtins.attrNames (
    lib.filterAttrs (_: fileType: fileType == "regular") directoryEntries
  );
  invalidTunnelFileNames = lib.filter (
    fileName: builtins.match "[a-zA-Z0-9_=+.-]{1,15}[.]conf" fileName == null
  ) tunnelFileNames;
  secretName = fileName: "wireguard-client/${fileName}";
  profileName = fileName: "WireGuard: ${lib.removeSuffix ".conf" fileName}";
  nmcli = lib.getExe' pkgs.networkmanager "nmcli";
  uuidFile = "/run/wireguard-client/uuids";
  importCommands = lib.concatMapStringsSep "\n" (
    fileName:
    let
      secretPath = config.sops.secrets.${secretName fileName}.path;
    in
    ''
      import_output="$(${nmcli} connection import --temporary type wireguard file ${lib.escapeShellArg secretPath})"
      uuid="$(printf '%s\n' "$import_output" | ${pkgs.gnused}/bin/sed -n 's/^Connection .* (\([0-9a-fA-F-]\{36\}\)) successfully added\.$/\1/p')"
      if [ -z "$uuid" ]; then
        printf 'Failed to determine the imported WireGuard UUID for %s\n' ${lib.escapeShellArg fileName} >&2
        printf '%s\n' "$import_output" >&2
        exit 1
      fi
      printf '%s\n' "$uuid" >> ${uuidFile}
      ${nmcli} connection modify --temporary uuid "$uuid" \
        connection.id ${lib.escapeShellArg (profileName fileName)} \
        connection.autoconnect no
    ''
  ) tunnelFileNames;
in
{
  assertions = [
    {
      assertion = invalidTunnelFileNames == [ ];
      message =
        "WireGuard tunnel files must be named after a valid interface and end in .conf: "
        + lib.concatStringsSep ", " invalidTunnelFileNames;
    }
  ];

  sops.secrets = builtins.listToAttrs (
    map (fileName: {
      name = secretName fileName;
      value = {
        sopsFile = encryptedTunnelDirectory + "/${fileName}";
        format = "binary";
        key = "";
        owner = "root";
        group = "root";
        mode = "0400";
        restartUnits = [ "wireguard-client-import.service" ];
      };
    }) tunnelFileNames
  );

  systemd.services.wireguard-client-import = lib.mkIf (tunnelFileNames != [ ]) {
    description = "Import SOPS WireGuard tunnels into NetworkManager";
    wantedBy = [ "multi-user.target" ];
    requires = [ "NetworkManager.service" ];
    after = [ "NetworkManager.service" ];
    partOf = [ "NetworkManager.service" ];
    environment.LC_ALL = "C";

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      RuntimeDirectory = "wireguard-client";
      RuntimeDirectoryMode = "0700";
      UMask = "0077";
    };

    script = ''
      set -euo pipefail
      : > ${uuidFile}
      ${importCommands}
    '';

    postStop = ''
      if [ -f ${uuidFile} ]; then
        while IFS= read -r uuid; do
          [ -z "$uuid" ] || ${nmcli} connection delete uuid "$uuid" || true
        done < ${uuidFile}
      fi
    '';
  };
}
