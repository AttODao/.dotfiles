{
  hosts = [
    "attodesk"
    "attolap"
  ];
  requires = [
    "skk"
    "qt6ct"
  ];
  homeModules = [ ./home.nix ];
}
