{
  hosts = [
    "attodesk"
    "attolap"
  ];
  requires = [ "open-deck-desktop" ];
  homeModules = [ ./home.nix ];
}
