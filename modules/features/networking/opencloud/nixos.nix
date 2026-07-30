{
  # OpenCloud reads this system file before its per-user configuration exists.
  environment.etc."OpenCloud/OpenCloud.conf".text = ''
    [Wizard]
    ServerUrl=https://cloud.attodao.cc
  '';
}
