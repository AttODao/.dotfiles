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

  wayland.windowManager.hyprland.settings.window_rule = [
    {
      match = {
        class = "^menu\\.kando\\.Kando$";
        title = "^Kando Menu$";
      };
      float = true;
      pin = true;
      move = "0 0";
      size = "100% 100%";
      border_size = 0;
      rounding = 0;
      no_anim = true;
      no_blur = true;
      opaque = true;
    }
  ];
}
