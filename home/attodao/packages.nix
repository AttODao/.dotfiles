{
  hostName,
  lib,
  pkgs,
  ...
}:
{
  home.packages =
    (with pkgs; [
      app2unit
      kdePackages.ark
      celluloid
      gh
      loupe
      mission-center
      musescore
      nil
      nixd
      pcmanfm
      qt6Packages.qt6ct
      quickshell
      ripgrep
      telegram-desktop
    ])
    ++ lib.optionals (hostName == "attodesk") [
      pkgs.jdk25
      pkgs.protonup-qt
    ];
}
