{
  pkgs,
  ...
}:
let
  cursorTheme = "Yanfei-Cursors";
  cursorSize = 48;
  cursorPackage = pkgs.stdenvNoCC.mkDerivation {
    pname = "yanfei-cursors";
    version = "1.0";
    src = pkgs.fetchurl {
      name = "yanfei-cursors.zip";
      url = "https://cloud.attodao.cc/remote.php/dav/public-files/cqsQAfeTRsTMbmU/yanfei-cursors.zip";
      hash = "sha256-l48eiQ3qqzhL6LMSneJ42PpKsWq2LaJHa5AR0g46bG0=";
    };
    sourceRoot = ".";
    nativeBuildInputs = [
      pkgs.hyprcursor
      pkgs.unzip
      pkgs.xcur2png
    ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/icons/${cursorTheme}
      cp -r cursors index.theme $out/share/icons/${cursorTheme}/

      work="$TMPDIR/yanfei-cursors-build"
      mkdir -p "$work/yanfei-cursors"
      cp -r cursors index.theme "$work/yanfei-cursors/"
      chmod -R u+w "$work/yanfei-cursors"

      hyprcursor-util --extract "$work/yanfei-cursors" >/dev/null
      substituteInPlace "$work/extracted_yanfei-cursors/manifest.hl" \
        --replace-fail "name = Extracted Theme" "name = ${cursorTheme}" \
        --replace-fail "description = Automatically extracted with hyprcursor-util" "description = 煙緋 マウスカーソル"
      (cd "$work" && hyprcursor-util --create extracted_yanfei-cursors >/dev/null)
      cp -r "$work/theme_${cursorTheme}/manifest.hl" "$work/theme_${cursorTheme}/hyprcursors" $out/share/icons/${cursorTheme}/

      runHook postInstall
    '';
  };
  cursorLeftPtr = "${cursorPackage}/share/icons/${cursorTheme}/cursors/left_ptr";
in
{
  home.pointerCursor = {
    package = cursorPackage;
    name = cursorTheme;
    size = cursorSize;
    gtk.enable = true;
    x11.enable = true;
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

  home.file.".xprofile".text = ''
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

  home.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
    SDL_IM_MODULE = "fcitx";

    XCURSOR_THEME = cursorTheme;
    XCURSOR_SIZE = toString cursorSize;
    HYPRCURSOR_THEME = cursorTheme;
    HYPRCURSOR_SIZE = toString cursorSize;
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
