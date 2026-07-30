{
  hosts = [
    "attodesk"
    "attolap"
  ];
  requires = [ "mozc-ut" ];
  homeModules = [ ./home.nix ];
}
