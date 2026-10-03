{
  hosts = [
    "attodesk"
    "attolap"
  ];
  homePackages = pkgs: [ pkgs.vscode ];
  homeModules = [ ./home.nix ];
}
