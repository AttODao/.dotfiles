{
  hosts = [ "attodesk" ];
  requires = [
    "musescore"
    "pipewire"
  ];
  homeModules = [ ./home.nix ];
}
