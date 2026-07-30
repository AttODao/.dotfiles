{
  hosts = [
    "attodesk"
    "attolap"
  ];
  requires = [
    "mozc-ut"
    "qt6ct"
  ];
  homeModules = [ ./home.nix ];
}
