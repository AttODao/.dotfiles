# attodesk NixOS configuration / refactored

元の `configuration.nix`、`flake.nix`、`home.nix` を役割ごとに分割した構成です。

## 反映方法

既存の設定ディレクトリで、まずバックアップを取ってから、このディレクトリの内容をコピーしてください。

```bash
cd ~/.dotfiles  # 実際の NixOS 設定ディレクトリに合わせて変更
cp configuration.nix configuration.nix.bak 2>/dev/null || true
cp home.nix home.nix.bak 2>/dev/null || true
cp flake.nix flake.nix.bak 2>/dev/null || true
```

`hardware-configuration.nix` は含めていません。既存のルート直下の `hardware-configuration.nix` をそのまま使う前提です。

```bash
nixos-rebuild build --flake .#attodesk
sudo nixos-rebuild switch --flake .#attodesk
```

## 構成

```text
flake.nix
hosts/
  attodesk/
    default.nix
modules/
  nixos/
    boot/
    core/
    desktop/
    hardware/
    programs/
    services/
home/
  attodao/
    default.nix
    packages.nix
    desktop/
    programs/
    services/
```

## 分割方針

- NixOS 全体の設定は `modules/nixos/` に配置
- ユーザー単位の Home Manager 設定は `home/attodao/` に配置
- Niri、Noctalia、fcitx5、Starship、foot、Wallpaper Engine などはソフトごとに分離
- ホスト固有の import 集約は `hosts/attodesk/default.nix` に配置

## 変更点

- `home.nix` の巨大な設定を Home Manager modules に分割
- `configuration.nix` のシステム設定を NixOS modules に分割
- `flake.nix` の参照先を `./configuration.nix` / `./home.nix` から `./hosts/attodesk` / `./home/attodao` に変更
- Niri の `load-configu-file` を `load-config-file` に修正
