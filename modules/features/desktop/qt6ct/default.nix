{
  hosts = [
    "attodesk"
    "attolap"
  ];
  homePackages = pkgs: [ pkgs.qt6Packages.qt6ct ];
}
