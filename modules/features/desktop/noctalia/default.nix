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
    "vscode"
  ];
  nixosModules = [ ./nixos.nix ];
  homeModules = [ ./home.nix ];
}
