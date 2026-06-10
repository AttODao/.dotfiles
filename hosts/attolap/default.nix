{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/locale.nix
    ../../modules/nixos/core/networking.nix
    ../../modules/nixos/core/users.nix
    ../../modules/nixos/core/packages.nix

    ../../modules/nixos/hardware
    ../../modules/nixos/boot/limine.nix
    ../../modules/nixos/desktop
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/services
    ../../modules/nixos/programs/nix-ld.nix
    ../../modules/nixos/security/login-pin.nix
  ];

  programs.zsh.enable = true;

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  attodao.loginPin = {
    enable = true;
    users = [ "attodao" ];
    services = [
      "greetd"
      "login"
    ];
    allowPasswordFallback = true;
  };

  system.stateVersion = "26.05";
}
