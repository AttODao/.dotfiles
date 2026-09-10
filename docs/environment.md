# 環境と操作

## ホスト

| ホスト | 役割 | 実機固有の設定 |
| --- | --- | --- |
| `attodesk` | デスクトップ | 3台の固定モニター、`/mnt/ssd1`・`/mnt/hdd1`、Scarlett・KURO、Solaar、Kando、ゲーム機能 |
| `attolap` | ノートPC | モニターのpreferred設定、電源プロファイル、UPower |

featureの導入先は各`default.nix`の`hosts`で決めます。`hostName`はモニター、保存先、codec、物理デバイスなどの値の差分にだけ使います。

## デスクトップ

NoctaliaはEverforestパレット、上部バー、下部Dock、天気、夜間色温度、メディア、通知、クリップボード、CalDAVカレンダーを提供します。Open Deck Desktopは両ホストのDockへ固定し、ゲームランチャーは`attodesk`だけへ固定します。

Hyprlandの主なキーバインドです。

| 操作 | キー |
| --- | --- |
| ターミナル | `Super+Enter` |
| ファイルマネージャー | `Super+E` |
| ランチャー | `Super+Space` |
| コントロールセンター | `Super+S` |
| カレンダー | `Super+K` |
| 画面ロック | `Super+L` |
| ウィンドウを閉じる | `Super+Q` |
| 範囲スクリーンショット | `Super+Shift+S` |
| ウィンドウスクリーンショット | `Super+Alt+Shift+S` |
| 画面スクリーンショット | `Super+Ctrl+Shift+S` |
| Hyprland再読み込み | `Super+Shift+R` |

スクリーンショットは選択中に画面を固定します。保存先は`attodesk`では`/mnt/hdd1/Pictures/Screenshots`、`attolap`では`~/Pictures/Screenshots`です。

## ストレージ

`attodesk`はラベル付きBtrfsボリュームを自動マウントします。

| ラベル | マウント先 |
| --- | --- |
| `ssd1` | `/mnt/ssd1` |
| `hdd1` | `/mnt/hdd1` |

`attodesk`のDocuments、Downloads、Music、Pictures、Videosは`/mnt/hdd1`を使います。`attolap`ではホームディレクトリを使います。

## メールとカレンダー

Thunderbirdは`attodao@attodao.cc`のIMAP/SMTPと`atsuatat@gmail.com`のGmailアカウントを定義します。Noctaliaは`https://mail.attodao.cc/radicale/`のCalDAVカレンダーを使います。

Thunderbirdのパスワードは初回起動時に入力し、システムの資格情報ストアへ保存します。NoctaliaのCalDAVパスワードは両ホストでSOPS暗号化して管理し、`/run/secrets/noctalia/calendar-password`から読み込みます。`mail.attodao.cc`を`192.168.0.100`へ解決するhosts設定は`attodesk`だけに適用されます。

## WireGuard

両ホストのWireGuard tunnelはホスト別にSOPS暗号化して管理します。復号された設定はNetworkManagerの一時プロファイルとして登録され、自動接続しません。各ホストのNoctalia NetworkパネルにあるVPN一覧から`WireGuard: <tunnel名>`を選択して接続・切断します。

## ログインPIN

Noctalia GreeterとTTYログインでは6桁PIN認証を使えます。両ホストのPIN hashはホスト別にSOPS暗号化して管理し、`/run/secrets/login-pin/attodao.pbkdf2`へroot専用権限で復号します。通常パスワードによるフォールバックも有効です。SOPS secretが存在しないホストでは、従来どおり`/etc/security/login-pin/attodao.pbkdf2`を使います。
