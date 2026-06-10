{ hostName, lib, ... }:
{
  networking = {
    inherit hostName;
    hosts = lib.mkIf (hostName == "attodesk") {
      "192.168.0.100" = [ "mail.attodao.cc" ];
    };
    networkmanager.enable = true;
  };
}
