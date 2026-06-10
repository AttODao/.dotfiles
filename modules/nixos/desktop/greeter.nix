{
  config,
  hostName,
  lib,
  pkgs,
  ...
}:

let
  monitorConfig =
    if hostName == "attodesk" then
      ''
        monitor = DP-1, 2560x1440@60, 0x0, 1, bitdepth, 10, cm, hdr
        monitor = HDMI-A-1, disable
        monitor = HDMI-A-2, disable
      ''
    else
      "monitor = , preferred, auto, 1";

  greeterCommand = pkgs.writeShellScript "regreet-hyprland" ''
    ${config.programs.regreet.package}/bin/regreet
    ${pkgs.hyprland}/bin/hyprctl dispatch exit || true
  '';

  greeterHyprlandConfig = pkgs.writeText "hyprland-greeter.conf" (
    monitorConfig
    + "\n"
    + builtins.replaceStrings [ "@GREETER_COMMAND@" ] [ "${greeterCommand}" ] (
      builtins.readFile ./greeter/hyprland.conf
    )
  );
in
{
  programs.regreet = {
    enable = true;

    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
      size = 16;
    };

    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };

    settings = {
      GTK.application_prefer_dark_theme = true;

      appearance.greeting_msg = "Welcome back, attodao";

      widget.clock = {
        format = "%Y-%m-%d  %H:%M";
        resolution = "1s";
      };

      commands = {
        reboot = [
          "systemctl"
          "reboot"
        ];
        poweroff = [
          "systemctl"
          "poweroff"
        ];
      };
    };

    extraCss = builtins.readFile ./greeter/regreet.css;
  };

  services.greetd.settings.default_session.command =
    lib.mkForce "${pkgs.dbus}/bin/dbus-run-session ${pkgs.hyprland}/bin/start-hyprland -- --config ${greeterHyprlandConfig}";
}
