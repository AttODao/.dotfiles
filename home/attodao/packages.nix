{ pkgs, ... }:
{
  home.packages = with pkgs; [
    app2unit
    kdePackages.ark
    floorp-bin
    kdePackages.dolphin
    nil
    nixd
    protonup-qt
    qt6Packages.qt6ct
    quickshell
    zed-editor
  ];
}
