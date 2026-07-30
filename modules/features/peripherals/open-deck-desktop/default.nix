{
  hosts = [
    "attodesk"
    "attolap"
  ];
  nixosModules = [ ./nixos.nix ];
  homeModules = [ ./home.nix ];
}
