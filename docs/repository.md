# リポジトリ構成

`attodao`用のNixOSホスト2台とHome Managerユーザー1人を管理するNix flakeです。

## 構成の組み立て

- `flake.nix`: 全NixOS・Home Manager出力を組み立てます。
- `lib/features.nix`: `modules/features/`以下を再帰的に検出し、feature定義を検証します。
- `modules/nixos/default.nix`: 全ホストに必要な最小のNixOS基盤を読み込みます。
- `home/attodao/default.nix`: ユーザー情報とHome Managerのstate versionを定義します。
- `hosts/<host>/default.nix`: 生成済みhardware設定と実機固有の設定を読み込みます。
- `modules/features/<category>/<name>/`: ソフトウェアの導入先ホスト、設定、パッケージ、依存関係、資産をまとめます。

`flake.nix`は同じfeature集合からNixOSとHome Managerを構成します。ホストとソフトウェアの対応表を別途作成しません。

## Feature定義

featureは`modules/features/<category>/<name>/default.nix`に置きます。分類用ディレクトリ自体には`default.nix`を置きません。

```nix
{
  hosts = [
    "attodesk"
    "attolap"
  ];
  requires = [ "another-feature" ];
  nixosModules = [ ./nixos.nix ];
  homeModules = [ ./home.nix ];
  systemPackages = pkgs: [ pkgs.example ];
  homePackages = pkgs: [ pkgs.example ];
}
```

`hosts`以外のフィールドは任意ですが、featureには少なくともmoduleまたはパッケージが必要です。resolverは未知のホスト、未対応フィールド、空feature、同名feature、重複ホスト、自己依存、未知の依存先、同じホストで有効でない依存先を拒否します。

## カテゴリ

- `audio-video`: 音声・映像再生、制作、録画、PipeWire
- `desktop`: デスクトップ環境、テーマ、ファイル管理、ユーティリティ
- `development`: 開発言語、エディタ、Git、開発CLI
- `gaming`: ゲーム、ランチャー、Proton連携
- `networking`: ブラウザ、通信、リモート接続、クラウド
- `peripherals`: マウス、デッキ、物理コントローラー
- `system`: ブート、認証、入力方式、基盤CLI、電源管理

## ホスト

- `attodesk`: Btrfsマウント、固定モニター、デスクトップ周辺機器、メディア・ゲーム機能を持つデスクトップ機です。
- `attolap`: 電源管理と共通グラフィカル環境を持つノートPCです。

ホストディレクトリには生成済みhardware設定、ストレージ、デバイス固有の音声設定、ローカルなhosts設定だけを置きます。ソフトウェアの所属はfeature定義で管理します。

## ホストの追加

`attofort`を追加する場合は、次の順序で行います。

1. `hosts/attofort/default.nix`を作成します。
2. `hosts/attofort/hardware-configuration.nix`へ対象実機で生成したhardware設定を配置します。
3. `flake.nix`の`hostNames`へ`"attofort"`を追加します。
4. `flake.nix`の`homeConfigurations`へ`attodao-attofort = mkHome "attofort";`を追加します。
5. 導入する各featureの`hosts`へ`"attofort"`を追加します。
6. `featureMatrix.attofort`、NixOS出力、Home Manager出力を評価します。

新しいホストにfeatureは自動導入されません。必要なソフトウェアを明示的に選択してください。

## 出力

- `nixosConfigurations.attodesk`
- `nixosConfigurations.attolap`
- `homeConfigurations.attodao-attodesk`
- `homeConfigurations.attodao-attolap`
- `homeConfigurations.attodao`: `attodao-attodesk`の互換エイリアス
- `featureMatrix.<host>`: 監査用の解決済みfeature名

## FlakeとGit

- 外部inputは`flake-inputs/flake.nix`に集約します。
- `nixpkgs`は`nixos-unstable`、Home ManagerとAAGLは対応する開発系列を追跡します。
- `hostName`と`inputs`は`specialArgs`と`extraSpecialArgs`から渡されます。
- `flake.lock`はGit管理対象です。input更新以外では`--no-write-lock-file`を使い、更新時は内容を確認してコミットします。
- 新規にimportするファイルは、評価前にGitへ追加してください。flakeは未追跡ファイルを参照できません。
