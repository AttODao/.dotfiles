# Home Managerモジュール

Home Manager構成は`flake.nix`で次を組み合わせます。

- `home/attodao/default.nix`: ユーザー情報と`home.stateVersion`
- `modules/features/<category>/<name>/default.nix`が選択するHome Manager module

手書きのHome Manager import一覧はありません。

## Featureの配置

- ユーザー設定は`modules/features/<category>/<name>/home.nix`に置きます。
- スクリプト、desktop entry、YAMLなどの資産も同じfeature内に置きます。
- パッケージだけのfeatureはdescriptorの`homePackages`を使います。
- 設定、activation、ファイル、ユーザーserviceがある場合はHome moduleを使います。
- NixOSとHome Managerの両方が必要な場合も一つのdescriptorで対応付けます。
- 生成するcommand、launcher、統合が他featureを必要とする場合は`requires`を宣言します。

## ホスト差分

featureの導入先はdescriptorの`hosts`で決めます。`hostName`はモニター配置、ストレージパス、codec、物理デバイス動作のような値の差分に限定します。

- `attodesk`: `/mnt/hdd1`のユーザーディレクトリ、固定モニター、HDR録画、Kando、Solaar、Wallpaper Engine、OpenCloud、PipeASIO、ゲームランチャー
- `attolap`: ホームディレクトリ内のユーザーフォルダ、可搬用モニター既定値、電源管理service

## 不変条件

- ユーザー名は`attodao`です。
- ホームディレクトリは`/home/attodao`です。
- `home.stateVersion = "26.05"`は明示的な依頼なしに変更しません。
- secretはHome Managerで宣言しません。
