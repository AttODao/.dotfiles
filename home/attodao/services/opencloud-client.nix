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
