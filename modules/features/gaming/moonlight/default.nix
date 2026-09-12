{
  hosts = [ "attodesk" ];
  requires = [ "wireguard-client" ];
  homePackages = pkgs: [ pkgs.moonlight-qt ];
}
