{
  hosts = [
    "attodesk"
    "attolap"
  ];
  requires = [
    "hyprland"
    "noctalia"
  ];
  nixosModules = [
    ./module.nix
    ./nixos.nix
  ];
}
