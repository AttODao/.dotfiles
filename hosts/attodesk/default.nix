{
  imports = [
    ./audio.nix
    ./hardware-configuration.nix
    ./mounts.nix
  ];

  networking.hosts."192.168.0.100" = [ "mail.attodao.cc" ];

  system.stateVersion = "26.05";
}
