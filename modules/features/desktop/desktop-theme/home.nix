{
  pkgs,
  ...
}:
let
  cursor = import ./cursor.nix { inherit pkgs; };
  inherit (cursor) cursorPackage cursorSize cursorTheme;
  cursorLeftPtr = "${cursorPackage}/share/icons/${cursorTheme}/cursors/left_ptr";
in
{
  home = {
    pointerCursor = {
      enable = true;
      package = cursorPackage;
      name = cursorTheme;
      size = cursorSize;
      gtk.enable = true;
      x11.enable = true;
    };

    file.".xprofile".text = ''
      export XMODIFIERS=@im=fcitx
      export QT_IM_MODULE=fcitx
      export SDL_IM_MODULE=fcitx

      export XCURSOR_THEME=${cursorTheme}
      export XCURSOR_SIZE=${toString cursorSize}
      export HYPRCURSOR_THEME=${cursorTheme}
      export HYPRCURSOR_SIZE=${toString cursorSize}

      if [ -r "$HOME/.Xresources" ]; then
        ${pkgs.xrdb}/bin/xrdb -merge "$HOME/.Xresources"
      fi

      ${pkgs.xsetroot}/bin/xsetroot -xcf "${cursorLeftPtr}" ${toString cursorSize}
    '';

    sessionVariables = {
      XMODIFIERS = "@im=fcitx";
      QT_IM_MODULE = "fcitx";
      SDL_IM_MODULE = "fcitx";

      XCURSOR_THEME = cursorTheme;
      XCURSOR_SIZE = toString cursorSize;
      HYPRCURSOR_THEME = cursorTheme;
      HYPRCURSOR_SIZE = toString cursorSize;
    };
  };

  xresources.properties = {
    "Xcursor.theme" = cursorTheme;
    "Xcursor.size" = cursorSize;
  };

  xdg.configFile."environment.d/10-cursor.conf".text = ''
    XCURSOR_THEME=${cursorTheme}
    XCURSOR_SIZE=${toString cursorSize}
    HYPRCURSOR_THEME=${cursorTheme}
    HYPRCURSOR_SIZE=${toString cursorSize}
  '';

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    colorScheme = "dark";
  };

  systemd.user.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
    SDL_IM_MODULE = "fcitx";

    XCURSOR_THEME = cursorTheme;
    XCURSOR_SIZE = toString cursorSize;
    HYPRCURSOR_THEME = cursorTheme;
    HYPRCURSOR_SIZE = toString cursorSize;

    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_AUTO_SCREEN_FACTOR = "1";

    MOZ_ENABLE_WAYLAND = "1";
  };
}
