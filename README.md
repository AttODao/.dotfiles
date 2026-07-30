# AttODesk NixOS Configuration

`attodao`用のNixOS / Home Manager構成です。デスクトップの`attodesk`とノートPCの`attolap`を、ソフトウェア単位のfeatureとホスト固有のhardware設定で管理します。

このリポジトリには個人環境向けのユーザー名、メールアドレス、ディスク構成、モニター構成が含まれています。第三者の環境へそのまま適用する用途は想定していません。

## 構成

| パス | 役割 |
| --- | --- |
| `flake.nix` | NixOSとホスト別Home Manager出力を組み立てます。 |
| `hosts/<host>/` | 生成済みhardware設定、ストレージ、実機固有値を管理します。 |
| `modules/features/<category>/<name>/` | ソフトウェアの導入先ホスト、設定、パッケージ、資産を管理します。 |
| `modules/nixos/` | 全ホストで必須のNixOS基盤を管理します。 |
| `home/attodao/default.nix` | ユーザー情報とHome Managerのstate versionを定義します。 |
| `docs/` | 構成、運用、環境詳細、特殊実装の説明を置きます。 |

## 初期セットアップ

1. リポジトリを配置します。

```bash
git clone <repository-url> ~/.dotfiles
cd ~/.dotfiles
```

2. 新しい実機では、対象ホストの`hardware-configuration.nix`を生成済み設定で置き換えます。

```bash
sudo install -m 644 /etc/nixos/hardware-configuration.nix \
  hosts/<host>/hardware-configuration.nix
sudo chown "$USER":users hosts/<host>/hardware-configuration.nix
```

`<host>`には`attodesk`または`attolap`を指定します。hardware設定は実機固有のため、既存ホストのファイルを別の実機へ流用しません。

3. 評価とビルドを確認してから適用します。

```bash
nix flake check --no-write-lock-file
sudo nixos-rebuild build --flake .#<host>
sudo nixos-rebuild switch --flake .#<host>
```

## 詳細

- [リポジトリ構成とfeature設計](docs/repository.md)
- [NixOSモジュール](docs/nixos.md)
- [Home Managerモジュール](docs/home-manager.md)
- [環境と操作](docs/environment.md)
- [特殊実装](docs/special-implementations.md)
- [作業手順と検証](docs/workflow.md)
