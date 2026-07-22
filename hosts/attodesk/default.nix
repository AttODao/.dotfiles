{ inputs, ... }:

{
  imports = [
    inputs.aagl.nixosModules.default

    ./hardware-configuration.nix
    ./mounts.nix

    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/locale.nix
    ../../modules/nixos/core/networking.nix
    ../../modules/nixos/core/users.nix
    ../../modules/nixos/core/packages.nix

    ../../modules/nixos/hardware

    ../../modules/nixos/boot/limine.nix

    ../../modules/nixos/desktop

    ../../modules/nixos/fonts.nix

    ../../modules/nixos/programs

    ../../modules/nixos/services

    ../../modules/nixos/security/login-pin.nix
  ];

  # OpenCloud Desktop reads this on Linux to prefill the server URL wizard.
  environment.etc."OpenCloud/OpenCloud.conf".text = ''
    [Wizard]
    ServerUrl=https://cloud.attodao.cc
  '';

  attodao.loginPin = {
    enable = true;
    users = [ "attodao" ];

    # greetd: ReGreet のログイン
    # login : Noctalia lock screen
    services = [
      "greetd"
      "login"
    ];

    # 最初は true 推奨。
    # PIN 動作確認後、PIN 専用にしたいなら false にする。
    allowPasswordFallback = true;
  };

  programs.gpu-screen-recorder.enable = true;

  # ※ インストール時の値から変更しないこと
  system.stateVersion = "26.05";
}
