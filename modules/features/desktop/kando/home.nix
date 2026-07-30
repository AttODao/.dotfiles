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

  wayland.windowManager.hyprland.settings.windowrule = [
    "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, float on"
    "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, pin on"
    "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, move 0 0"
    "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, size 100% 100%"
    "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, border_size 0"
    "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, rounding 0"
    "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, no_anim on"
    "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, no_blur on"
    "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, opaque on"
  ];
}
