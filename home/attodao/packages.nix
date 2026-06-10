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
      cloudflared
      kdePackages.ark
      musescore
      nil
      nixd
      pcmanfm
      qt6Packages.qt6ct
      quickshell
      telegram-desktop
    ])
    ++ lib.optionals (hostName == "attodesk") [
      pkgs.protonup-qt
    ];
}
