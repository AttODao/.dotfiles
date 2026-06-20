{
  hostName,
  lib,
  pkgs,
  ...
}:
let
  localDirectory = "/mnt/hdd1/nextcloud";
  nextcloud = "${pkgs.nextcloud-client}/bin/nextcloud";
  nextcloudWithDefaults = pkgs.writeShellScriptBin "nextcloud" ''
    if [ "$1" = "--quit" ]; then
      exec ${nextcloud} "$@"
    fi

    mkdir -p ${localDirectory}
    exec ${nextcloud} \
      --overrideserverurl https://cloud.attodao.cc \
      --overridelocaldir ${localDirectory} \
      "$@"
  '';
in
lib.mkIf (hostName == "attodesk")
{
  home.packages = [
    pkgs.nextcloud-client
  ];

  services.nextcloud-client = {
    enable = true;
    package = nextcloudWithDefaults;
    startInBackground = true;
  };

  systemd.user.services.nextcloud-client.Unit.RequiresMountsFor = [
    localDirectory
  ];
}
