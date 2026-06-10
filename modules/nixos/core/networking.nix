{
  networking = {
    hostName = "attodesk";
    hosts."192.168.0.100" = [ "mail.attodao.cc" ];
    networkmanager.enable = true;
  };
}
