{ inputs, pkgs, ... }:
{
  # フリーでないパッケージを許可
  nixpkgs.config.allowUnfree = true;

  # AAGL 用の substituter / trusted key など
  nix.settings = inputs.aagl.nixConfig // {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
  ];

  # Home Manager が既存ファイルと衝突した場合のバックアップ拡張子
  home-manager.backupFileExtension = "backup";
}
