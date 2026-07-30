{
  hosts = [ "attodesk" ];
  nixosModules = [ ./nixos.nix ];
  homeModules = [ ./home.nix ];
}
