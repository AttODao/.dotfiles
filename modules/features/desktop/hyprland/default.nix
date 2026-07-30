{
  hosts = [
    "attodesk"
    "attolap"
  ];
  requires = [
    "app2unit"
    "desktop-theme"
    "foot"
    "mozc-ut"
    "noctalia"
    "pcmanfm"
  ];
  nixosModules = [ ./nixos.nix ];
  homeModules = [ ./home.nix ];
}
