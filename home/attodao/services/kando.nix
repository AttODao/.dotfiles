{ pkgs, ... }:
{
  home.packages = [
    pkgs.kando
  ];

  systemd.user.services.kando = {
    Unit = {
      Description = "Kando pie menu";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.kando}/bin/kando";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
