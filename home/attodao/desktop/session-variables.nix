{ config, ... }:
{
  systemd.user.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_AUTO_SCREEN_FACTOR = "1";

    MOZ_ENABLE_WAYLAND = "1";

    DISPLAY = ":0";
    XAUTHORITY = "${config.home.homeDirectory}/.Xauthority";
    SDL_VIDEODRIVER = "x11";
  };
}
