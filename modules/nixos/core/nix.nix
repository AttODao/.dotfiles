{ inputs, ... }:
{
  # フリーでないパッケージを許可
  nixpkgs.config.allowUnfree = true;

  # AAGL 用の substituter / trusted key など
  nix.settings = inputs.aagl.nixConfig;

  # Home Manager が既存ファイルと衝突した場合のバックアップ拡張子
  home-manager.backupFileExtension = "backup";
}
