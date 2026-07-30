{
  hosts = [
    "attodesk"
    "attolap"
  ];
  requires = [
    "discord"
    "floorp"
    "foot"
    "open-deck-desktop"
    "pcmanfm"
    "quickshell"
    "thunderbird"
    "zed"
  ];
  nixosModules = [ ./nixos.nix ];
  homeModules = [ ./home.nix ];
}
