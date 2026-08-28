# NixOSモジュール

NixOS構成は`flake.nix`で次の3系統を組み合わせます。

- `hosts/<host>/default.nix`
- `modules/nixos/default.nix`
- `modules/features/<category>/<name>/default.nix`が選択するNixOS module

## 共通基盤

`modules/nixos/`には全ホストで必須の設定だけを置きます。

- `core/`: Nix、Home Manager統合、locale、ネットワーク、ユーザー
- `hardware/`: Bluetooth、graphics、input、thermal

ブートローダーとその資産はソフトウェアfeatureです。Limineは`modules/features/system/limine/`で管理します。

## Featureとホストの境界

- NixOS実装は`modules/features/<category>/<name>/nixos.nix`に置きます。
- カスタムパッケージは同じfeature内の`package.nix`に置きます。
- 導入する全ホストはdescriptorの`hosts`へ列挙します。
- 統合や実行時前提となるfeatureは`requires`で宣言します。
- feature全体の有効・無効を`hostName`条件で切り替えません。
- モニター構成、保存先、codec、物理デバイスのような値だけは、複数ホスト向けfeature内で`hostName`により切り替えられます。

## ホスト固有設定

- `hosts/attodesk/default.nix`: hardware、ストレージ、デバイス固有audio設定を読み込みます。
- `hosts/attodesk/mounts.nix`: Btrfsマウントとsystem所有ディレクトリを定義します。
- `hosts/attodesk/audio.nix`: ScarlettとKUROのデバイスルールを定義します。
- `hosts/attolap/default.nix`: 生成済みノートPC hardware設定を読み込みます。

## 不変条件

- `system.stateVersion = "26.05"`は明示的な依頼なしに変更しません。
- `hardware-configuration.nix`は実機固有の生成物として扱い、整形や共通化をしません。
- secretの平文とAge秘密鍵はNix storeやGitへ保存しません。SOPS暗号化済みのPIN hash、Noctalia password、WireGuard設定だけをGitで管理します。
- マウント配下のsystem所有ディレクトリには`systemd.tmpfiles.rules`を優先します。
