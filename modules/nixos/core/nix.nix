{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = lib.mkForce [
      "root"
      "@wheel"
    ];
  };

  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
  ];

  home-manager.backupFileExtension = "backup";
}
