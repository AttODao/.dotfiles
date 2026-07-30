{
  hosts = [
    "attodesk"
    "attolap"
  ];
  requires = [ "pipewire" ];
  homeModules = [ ./home.nix ];
}
