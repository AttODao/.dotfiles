# 特殊実装

以下は一般的なパッケージ設定ではなく、ハードウェア、既存データ、または外部ソフトウェアの制約に対応する実装です。

- `lib/features.nix`: カテゴリを再帰的に検出し、featureディレクトリで探索を止めることで、資産用ディレクトリを登録なしで扱います。
- `modules/features/system/limine/`: Limine、Plymouthテーマ、デスクトップ専用の低遅延kernel設定を一つのfeatureで管理します。低遅延設定はkernelの緩和策とwatchdogを無効化します。
- `hosts/attodesk/audio.nix`: Scarlett USBオーディオのunderrun回避と、KUROキャプチャーカード入力を物理出力へ自動再生しない仮想ステレオソース化を行います。
- `modules/features/system/mozc-ut/home.nix`: upstreamがビルド中に取得する辞書をflake inputとnixpkgsの固定ソースへ置換し、Home Manager側の自動起動を抑制します。
- `modules/features/system/login-pin/`: PINをプロセス引数に出さずfd経由でハッシュし、PAMでは共有認証トークンを`pam_unix`より先に消費します。`greetd`では`login`サブスタックより先へ配置します。
- `modules/nixos/core/secrets.nix`: ホストのAge鍵でSOPS secretを復号し、login PINはroot専用、Noctalia passwordはユーザー専用のruntime fileとして公開します。未移行ホストは既存credentialを維持します。
- `modules/features/networking/wireguard-client/`: ホスト別のSOPS暗号化済みWireGuard設定を列挙し、復号後だけNetworkManagerの一時プロファイルへ登録します。永続プロファイルと自動接続は作成せず、Noctaliaから接続先を選択します。
- `modules/features/system/nix-ld/nixos.nix`: LWJGL/GLFW、OpenAL、Minecraft narratorが動的に要求するライブラリを個別に追加します。
- `modules/features/desktop/hyprland/home.nix`: Home Managerの生成形式を強制し、カーソルを含まないスクリーンショットの制約と、IME・portalの起動順を明示します。
- `modules/features/desktop/desktop-theme/home.nix`: Xcursor素材しか提供されないテーマからHyprcursorテーマを生成します。
- `modules/features/gaming/pipeasio/`: 既存Proton prefixへregistryを注入し、ProtonがUnix bridgeを発見できるよう`WINEDLLPATH`を設定します。
- `modules/features/desktop/noctalia/`: Noctaliaから呼ばれる録画実行ファイルを差し替え、HDR映像をX互換のSDRへ変換します。
- `modules/nixos/hardware/input.nix`: WineがDualSenseをhidraw経由で直接扱うため、ゲームデバイスudevルールと権限を追加します。
- `modules/features/peripherals/open-deck-desktop/`: ユーザー所有AppImageではElectronのsetuid sandboxを導入できないため無効化し、mutableなAppImageをactivation時に更新します。
- `modules/features/gaming/pandora-launcher/`: 日本語localeを英語UTF-8へ固定し、Minecraft versionとloaderが一致するJARだけを選択します。候補が同数なら任意に選ばず失敗します。
- `modules/features/peripherals/solaar/rules.yaml`: MX MasterのジェスチャーとKandoの押下・解放イベントをSolaarのbutton diversionで変換します。
- `modules/features/networking/opencloud/`: per-user設定が存在する前に読み込まれるsystem設定を生成し、upstreamのautostartをsystemd管理へ一本化します。
- `modules/features/networking/ssh/home.nix`: OpenSSHがHome Managerのstore symlinkを拒否するため、実ファイルとして設定を配置します。
