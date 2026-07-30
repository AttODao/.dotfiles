{
  hosts = [
    "attodesk"
    "attolap"
  ];
  homeModules = [ ./home.nix ];
  homePackages = pkgs: [ pkgs.pcmanfm ];
}
