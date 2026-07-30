{
  hosts = [ "attodesk" ];
  requires = [
    "kando"
    "noctalia"
  ];
  nixosModules = [ ./nixos.nix ];
  homeModules = [ ./home.nix ];
}
