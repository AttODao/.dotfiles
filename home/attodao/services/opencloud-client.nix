{
  hostName,
  lib,
  pkgs,
  ...
}:
lib.mkIf (hostName == "attodesk")
{
  home.packages = [
    pkgs.opencloud-desktop
  ];

  # Use the systemd service as the single startup path for OpenCloud.
  xdg.configFile."autostart/OpenCloud.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=OpenCloud Desktop
    Hidden=true
  '';

  # Some XDG autostart implementations also scan the leftover backup entry.
  xdg.configFile."autostart/OpenCloud.desktop.backup" = {
    force = true;
    text = ''
      [Desktop Entry]
      Type=Application
      Name=OpenCloud Desktop
      Hidden=true
    '';
  };

  # The package ships an identical opencloudcmd.desktop launcher.
  xdg.dataFile."applications/opencloudcmd.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=OpenCloud Desktop
    Hidden=true
  '';

  systemd.user.services.opencloud = {
    Unit = {
      Description = "OpenCloud desktop client";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.opencloud-desktop}/bin/opencloud";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
