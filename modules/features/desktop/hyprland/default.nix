{
  hosts = [
    "attodesk"
    "attolap"
  ];
  requires = [
    "app2unit"
    "desktop-theme"
    "foot"
    "skk"
    "noctalia"
    "pcmanfm"
  ];
  nixosModules = [ ./nixos.nix ];
  homeModules = [ ./home.nix ];
}
