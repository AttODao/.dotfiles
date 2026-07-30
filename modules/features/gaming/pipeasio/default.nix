{
  hosts = [ "attodesk" ];
  requires = [
    "pipewire"
    "steam"
  ];
  nixosModules = [ ./nixos.nix ];
  homeModules = [ ./home.nix ];
}
