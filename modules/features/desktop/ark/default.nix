{
  hosts = [
    "attodesk"
    "attolap"
  ];
  homePackages = pkgs: [ pkgs.kdePackages.ark ];
}
