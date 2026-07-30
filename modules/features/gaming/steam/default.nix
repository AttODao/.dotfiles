{
  hosts = [ "attodesk" ];
  requires = [ "pcmanfm" ];
  nixosModules = [ ./nixos.nix ];
  homeModules = [ ./home.nix ];
}
