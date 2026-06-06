{ pkgs, ... }:
let
  pcmanfmDesktopEntry = builtins.replaceStrings [ "@PCMANFM@" ] [ "${pkgs.pcmanfm}/bin/pcmanfm" ] (
    builtins.readFile ./xdg/pcmanfm.desktop
  );
  pcmanfmIcon =
    pkgs.runCommandLocal "pcmanfm-icon.png"
      {
        nativeBuildInputs = [ pkgs.librsvg ];
      }
      ''
        rsvg-convert -w 256 -h 256 \
          ${pkgs.papirus-icon-theme}/share/icons/Papirus/64x64/apps/system-file-manager.svg \
          > $out
      '';
in
{
  xdg = {
    enable = true;

    dataFile."icons/hicolor/256x256/apps/pcmanfm.png".source = pcmanfmIcon;

    dataFile."applications/pcmanfm.desktop".text = pcmanfmDesktopEntry;

    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "pcmanfm.desktop";
        "x-directory/normal" = "pcmanfm.desktop";
        "x-scheme-handler/steam" = "steam.desktop";
        "x-scheme-handler/steamlink" = "steam.desktop";
      };
    };
  };
}
