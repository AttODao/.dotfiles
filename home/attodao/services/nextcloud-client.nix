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
    configFile="''${XDG_CONFIG_HOME:-$HOME/.config}/Nextcloud/nextcloud.cfg"

    if [ "$1" = "--quit" ]; then
      exec ${nextcloud} "$@"
    fi

    mkdir -p ${localDirectory}

    if [ -r "$configFile" ] && ${pkgs.gnugrep}/bin/grep -q '^0\\url=https://cloud\.attodao\.cc$' "$configFile"; then
      exec ${nextcloud} "$@"
    fi

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

  xdg.configFile."autostart/Nextcloud.desktop" = {
    force = true;
    text = ''
      [Desktop Entry]
      Name=Nextcloud
      GenericName=File Synchronizer
      Exec=nextcloud --background
      Terminal=false
      Icon=Nextcloud
      Categories=Network
      Type=Application
      StartupNotify=false
      Hidden=true
      X-GNOME-Autostart-enabled=false
    '';
  };

  services.nextcloud-client = {
    enable = true;
    package = nextcloudWithDefaults;
    startInBackground = true;
  };

  systemd.user.services.nextcloud-client.Unit.RequiresMountsFor = [
    localDirectory
  ];
}
