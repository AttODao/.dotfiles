{ pkgs, ... }:
{
  home.packages = with pkgs; [
    app2unit
    cloudflared
    kdePackages.ark
    nil
    nixd
    pcmanfm
    protonup-qt
    qt6Packages.qt6ct
    quickshell
    telegram-desktop
  ];
}
