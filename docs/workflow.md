# 作業手順

## 検索

最初に`rg`を使います。

```bash
rg --files -g '!result/**'
rg 'pattern' -g '!result/**'
```

ビルド済みclosureを扱う依頼以外では`result/`を検索しません。

## 編集

- 手作業による編集には`apply_patch`を使います。
- 既存のユーザー変更を保持します。
- 任意のソフトウェアはホストimportや包括的なパッケージ一覧へ追加せず、category内のfeatureとして追加します。
- コメントは自明でない挙動を説明する場合だけ追加します。
- 新規にimportするファイルは評価前にGitへ追加します。

```bash
git add path/to/new-file.nix
```

## ソフトウェアの追加

1. 適切なカテゴリに`modules/features/<category>/<name>/default.nix`を作成します。
2. `hosts`へ導入対象の全ホストを記述します。
3. パッケージだけの場合は`homePackages`または`systemPackages`を使います。
4. 設定が必要な場合は`home.nix`、`nixos.nix`、`package.nix`、資産を同じfeature内へ置きます。
5. 統合または実行時前提は`requires`へ追加します。
6. 新規ディレクトリをGitへ追加し、両ホストのfeature matrixを評価します。

`flake.nix`、hostファイル、`home/attodao/default.nix`に二重のimportを追加しません。外部flake inputだけは`flake-inputs/flake.nix`にも追加します。

## 日常操作

構成だけを確認する場合は、次を実行します。

```bash
nix eval --no-write-lock-file .#nixosConfigurations.attodesk.config.system.build.toplevel.drvPath
```

Home Managerだけを適用する場合は、ホストに対応する出力を指定します。

```bash
home-manager switch --flake .#attodao-attodesk
```

`attolap`では`attodao-attolap`を使います。`attodao`は`attodao-attodesk`の互換エイリアスです。

flake inputを更新する場合は、lock file更新とNixOS適用を明示的に行います。

```bash
nix flake update
sudo nixos-rebuild switch --flake .#attodesk
```

## 検証

通常の確認では`--no-write-lock-file`を使います。

```bash
nix eval --no-write-lock-file --raw .#nixosConfigurations.attodesk.config.system.build.toplevel.drvPath
nix eval --no-write-lock-file --raw .#nixosConfigurations.attolap.config.system.build.toplevel.drvPath
nix eval --no-write-lock-file --raw .#homeConfigurations.attodao-attodesk.activationPackage.drvPath
nix eval --no-write-lock-file --raw .#homeConfigurations.attodao-attolap.activationPackage.drvPath
nix eval --no-write-lock-file --json .#featureMatrix.attodesk
nix eval --no-write-lock-file --json .#featureMatrix.attolap
nix flake check --no-write-lock-file
```

ホスト別の値を確認する例です。

```bash
nix eval --no-write-lock-file --json .#nixosConfigurations.attodesk.config.networking.hostName
nix eval --no-write-lock-file --json .#homeConfigurations.attodao-attodesk.config.home.packages
```

ローカルで完全にビルドする場合です。

```bash
sudo nixos-rebuild build --flake .#attodesk
home-manager build --flake .#attodao-attodesk
```

適用が必要な場合だけ実行します。

```bash
sudo nixos-rebuild switch --flake .#attodesk
home-manager switch --flake .#attodao-attodesk
```

## 注意が必要な領域

- `hardware-configuration.nix`: 生成済みで実機固有です。
- `system.stateVersion`と`home.stateVersion`: 内容を理解せず変更しません。
- `/mnt/hdd1`と`/mnt/ssd1`: `attodesk`のストレージ前提です。
- PAMとログインPIN: 誤りがログイン不能につながるため慎重に検証します。
- Mail、CalDAV、SSH、Cloudflare設定: credentialを追加しません。
- `flake.lock`: Git管理対象です。input更新以外では`--no-write-lock-file`を使い、更新時は内容を確認してコミットします。
