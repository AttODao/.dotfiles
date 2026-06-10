# AttODesk NixOS Configuration

`attodao` 用の NixOS / Home Manager 構成です。デスクトップの `attodesk` とノートPCの
`attolap` を、共通モジュールとホスト名による条件分岐で管理します。

このリポジトリには個人環境向けのユーザー名、メールアドレス、ディスク構成、モニター構成が
含まれています。そのまま第三者の環境へ適用する用途は想定していません。

## Hosts

| ホスト | 用途 | 主な差分 |
| --- | --- | --- |
| `attodesk` | デスクトップ | 3画面、`/mnt/hdd1` のユーザーディレクトリ、Wallpaper Engine、StreamController、Solaar、Kando、ゲームランチャー |
| `attolap` | ノートPC | 単一画面、ホーム内のユーザーディレクトリ、電源プロファイル、UPower |

ホスト固有値は設定ファイルを複製せず、共有モジュール内の
`hostName == "attodesk"` などの条件で切り替えています。

## 主な構成

- NixOS unstable (`nixpkgs/master`)
- Home Manager
- Hyprland / XWayland
- Noctalia ShellとEverforestコミュニティパレット
- ReGreet
- LimineとカスタムPlymouthテーマ
- PipeWire
- fcitx5-mozc-ut
- Floorp、Thunderbird、Zed、Foot、PCManFM
- Steam、Prism Launcher、OBS Studio、MuseScore
- Open Deck Desktop
- OpenSSHクライアント・サーバー

fcitx5-mozc-utは
[`merge-ut-dictionaries`](https://github.com/utuhiro78/merge-ut-dictionaries) と各辞書の
flake inputからビルドします。

## ディレクトリ構成

```text
.
├── flake.nix
├── hosts/
│   ├── attodesk/
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   └── mounts.nix
│   └── attolap/
│       ├── default.nix
│       └── hardware-configuration.nix
├── modules/nixos/
│   ├── boot/
│   ├── core/
│   ├── desktop/
│   ├── hardware/
│   ├── programs/
│   ├── security/
│   └── services/
└── home/attodao/
    ├── desktop/
    ├── programs/
    ├── services/
    ├── default.nix
    └── packages.nix
```

- `hosts/<hostname>/default.nix`: ホストが利用するNixOSモジュール
- `modules/nixos/`: システム全体の共通設定
- `home/attodao/`: `attodao` ユーザーのHome Manager設定
- `flake.nix`: input、ホスト一覧、NixOSとHome Managerの組み立て

## セットアップ

### 1. リポジトリを配置

```bash
git clone <repository-url> ~/.dotfiles
cd ~/.dotfiles
```

### 2. Hardware configurationを配置

対象マシンで生成したファイルを、対応するホストディレクトリへ配置します。

```bash
sudo nixos-generate-config
sudo cp /etc/nixos/hardware-configuration.nix \
  ~/.dotfiles/hosts/attolap/hardware-configuration.nix
sudo chown "$USER":users \
  ~/.dotfiles/hosts/attolap/hardware-configuration.nix
```

`attolap` の同ファイルは現在プレースホルダーです。実機で生成した内容へ置き換えるまで、
完全なNixOSビルドはできません。

### 3. ビルドして適用

まず評価とビルドだけを行います。

```bash
sudo nixos-rebuild build --flake .#attodesk
```

問題がなければ適用します。

```bash
sudo nixos-rebuild switch --flake .#attodesk
```

ノートPCではホスト名を変更します。

```bash
sudo nixos-rebuild switch --flake .#attolap
```

## 日常的な操作

設定を確認するだけの場合:

```bash
nix eval .#nixosConfigurations.attodesk.config.system.build.toplevel.drvPath
```

Home Managerだけを適用する場合:

```bash
home-manager switch --flake .#attodao
```

flake inputを更新する場合:

```bash
nix flake update
sudo nixos-rebuild switch --flake .#attodesk
```

このリポジトリでは `flake.lock` をGit管理対象外にしています。再現性を優先する運用へ
変更する場合は、`.gitignore` から `flake.lock` を削除してコミットしてください。

## デスクトップ環境

### Noctalia

- Everforestパレット
- 上部バーと下部Dock
- 天気、夜間色温度、メディア、通知、クリップボード
- SOGo CalDAVカレンダー
- Open Deckを両ホストのDockへ固定
- ゲームランチャーは`attodesk`のみDockへ固定

### Hyprland

主なキーバインド:

| 操作 | キー |
| --- | --- |
| ターミナル | `Super+Enter` |
| ファイルマネージャー | `Super+E` |
| ランチャー | `Super+Space` |
| コントロールセンター | `Super+S` |
| ロック | `Super+L` |
| ウィンドウを閉じる | `Super+Q` |
| 範囲スクリーンショット | `Super+Shift+S` |
| ウィンドウスクリーンショット | `Super+Alt+Shift+S` |
| 画面スクリーンショット | `Super+Ctrl+Shift+S` |
| Hyprland再読み込み | `Super+Shift+R` |

スクリーンショットは選択中に画面を固定します。保存先は次のとおりです。

- `attodesk`: `/mnt/hdd1/Pictures/Screenshots`
- `attolap`: `~/Pictures/Screenshots`

## ストレージ

`attodesk` はラベル付きBtrfsボリュームを自動マウントします。

| ラベル | マウント先 |
| --- | --- |
| `ssd1` | `/mnt/ssd1` |
| `hdd1` | `/mnt/hdd1` |

`attodesk` のDocuments、Downloads、Music、Pictures、Videosは`/mnt/hdd1`上に作成されます。
`attolap` では通常どおりホームディレクトリ内に作成されます。

## メールとカレンダー

Thunderbirdには次のアカウント定義が含まれます。

- `attodao@attodao.cc`: IMAP / SMTP
- `atsuatat@gmail.com`: Gmail
- SOGo CalDAVカレンダー

パスワードはNix設定へ保存しません。初回起動時にThunderbirdへ入力し、システムの
資格情報ストアへ保存します。

`mail.attodao.cc`を`192.168.0.100`へ解決する`/etc/hosts`設定は`attodesk`だけに
適用されます。

## ログインPIN

ReGreetとログイン用に6桁PIN認証を追加しています。NixOS適用後にPINを設定します。

```bash
sudo set-login-pin attodao
```

PINのハッシュは`/etc/security/login-pin/attodao.pbkdf2`へroot専用権限で保存されます。
通常パスワードによるフォールバックも有効です。

## ホストの追加

例として`attofort`を追加する場合:

1. `hosts/attofort/default.nix`を作成する
2. `hosts/attofort/hardware-configuration.nix`を配置する
3. `flake.nix`の`hostNames`へ`"attofort"`を追加する
4. 必要な共有モジュールで`hostName == "attofort"`の条件を追加する
5. `nix eval .#nixosConfigurations.attofort.config.networking.hostName --raw`で確認する

設定差分が小さい場合はホスト専用profileを作らず、既存の共有モジュール内で条件分岐します。

## 注意事項

- `system.stateVersion`と`home.stateVersion`は、内容を理解せず変更しないでください。
- `attodesk`のモニター名、解像度、ディスクラベルは実機構成に依存します。
- Open Deck DesktopはHome Manager適用時にGitHub ReleasesからAppImageを確認します。
- メール、CalDAV、GitHub APIへの接続にはネットワークが必要です。
- 適用前に必ず`nixos-rebuild build`で評価とビルドを確認してください。
