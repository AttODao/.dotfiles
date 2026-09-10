# Secret管理

login PIN hash、NoctaliaのCalDAV password、WireGuard設定をSOPSで暗号化し、暗号化済みファイルだけをGitで管理します。Age秘密鍵、復号済みファイル、その他のアプリケーションcredentialは対象外です。

## 配置

暗号化済みsecretは次のパスに置きます。

```text
secrets/login-pin/attodesk/attodao.pbkdf2
secrets/login-pin/attolap/attodao.pbkdf2
secrets/noctalia/calendar-password
secrets/wireguard-client/attodesk/<tunnel>.conf
secrets/wireguard-client/attolap/<tunnel>.conf
```

login PIN hashとWireGuard設定はホスト別、Noctalia passwordは両ホスト共通です。

復号時のパスと権限です。

| Secret | Runtime path | Owner | Mode |
| --- | --- | --- | --- |
| login PIN hash | `/run/secrets/login-pin/attodao.pbkdf2` | `root:root` | `0400` |
| Noctalia password | `/run/secrets/noctalia/calendar-password` | `attodao:users` | `0400` |
| WireGuard設定 | `/run/secrets/wireguard-client/<tunnel>.conf` | `root:root` | `0400` |

## Age鍵

ホストごとに独立したAge鍵を使います。秘密鍵は次のパスへroot所有、mode `0600`で配置し、Gitへ追加しません。

```text
/var/lib/sops-nix/key-attodesk.txt
/var/lib/sops-nix/key-attolap.txt
```

各ホストのrecipientは`.sops.yaml`へ登録済みです。

```text
attodesk: age1xgjuuz8g7sfx3ajh8u3jtnzghu8h33y5ayeszn37fmhl8rcw0d8qj0k98l
attolap:  age1x9rk8uted32ldfs65mwy4lmhcvaqpq2agt0waz4qpxhd495dd3cq52kfrd
```

初期導入用に生成した作業用鍵を正式な配置先へコピーし、recipientが一致することを確認します。sops-nixが作業用鍵を参照することはありません。

```bash
age_keygen="$(nix build --no-link --print-out-paths nixpkgs#age)/bin/age-keygen"
source_key=/home/attodao/.config/sops/age/key-attodesk.txt

sudo install -D -m 0600 -o root -g root \
  "$source_key" /var/lib/sops-nix/key-attodesk.txt
test "$(sudo "$age_keygen" -y /var/lib/sops-nix/key-attodesk.txt)" = \
  age1xgjuuz8g7sfx3ajh8u3jtnzghu8h33y5ayeszn37fmhl8rcw0d8qj0k98l
```

`attolap`では、生成済みの作業用鍵を次のように配置してrecipientを確認します。

```bash
age_keygen="$(nix build --no-link --print-out-paths nixpkgs#age)/bin/age-keygen"
source_key=/home/attodao/.config/sops/age/key-attolap.txt

sudo install -D -m 0600 -o root -g root \
  "$source_key" /var/lib/sops-nix/key-attolap.txt
test "$(sudo "$age_keygen" -y /var/lib/sops-nix/key-attolap.txt)" = \
  age1x9rk8uted32ldfs65mwy4lmhcvaqpq2agt0waz4qpxhd495dd3cq52kfrd
```

各秘密鍵はGit以外の安全な場所へバックアップします。正式パスとバックアップを確認してから、作業用鍵を`shred -u "$source_key"`で削除します。

## 初期化

このリポジトリでは暗号化済みファイルが存在するsecretだけをNixOSへ登録します。新規ファイルはflake評価前に`git add`してください。

既存の`attodesk` PIN hashを、値を端末へ表示せず暗号化します。

```bash
install -d secrets/login-pin/attodesk
sops_bin="$(nix build --no-link --print-out-paths nixpkgs#sops)/bin/sops"

sudo cat /etc/security/login-pin/attodao.pbkdf2 | \
  sudo SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key-attodesk.txt \
  "$sops_bin" --config .sops.yaml encrypt \
    --input-type binary --output-type binary \
    --filename-override secrets/login-pin/attodesk/attodao.pbkdf2 \
    --output secrets/login-pin/attodesk/attodao.pbkdf2 /dev/stdin
sudo chown attodao:users secrets/login-pin/attodesk/attodao.pbkdf2
chmod 0644 secrets/login-pin/attodesk/attodao.pbkdf2
```

Noctalia passwordを対話入力して暗号化します。

```bash
install -d secrets/noctalia
sops_bin="$(nix build --no-link --print-out-paths nixpkgs#sops)/bin/sops"

IFS= read -r -s noctalia_calendar_password
printf '\n' >&2
printf '%s\n' "$noctalia_calendar_password" | \
  sudo SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key-attodesk.txt \
  "$sops_bin" --config .sops.yaml encrypt \
    --input-type binary --output-type binary \
    --filename-override secrets/noctalia/calendar-password \
    --output secrets/noctalia/calendar-password /dev/stdin
unset noctalia_calendar_password
sudo chown attodao:users secrets/noctalia/calendar-password
chmod 0644 secrets/noctalia/calendar-password
```

WireGuardの接続設定全体をbinary secretとして暗号化します。ファイル名からNetworkManagerのinterface名を作るため、`<tunnel>`は英数字と`_`、`=`、`+`、`.`、`-`を使った15文字以内の名前にします。

```bash
install -d secrets/wireguard-client/attodesk
sops_bin="$(nix build --no-link --print-out-paths nixpkgs#sops)/bin/sops"
tunnel_name=example
source_config=/path/to/server-provided.conf

sudo SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key-attodesk.txt \
  "$sops_bin" --config .sops.yaml encrypt \
    --input-type binary --output-type binary \
    --filename-override "secrets/wireguard-client/attodesk/$tunnel_name.conf" \
    --output "secrets/wireguard-client/attodesk/$tunnel_name.conf" \
    "$source_config"
sudo chown attodao:users "secrets/wireguard-client/attodesk/$tunnel_name.conf"
chmod 0644 "secrets/wireguard-client/attodesk/$tunnel_name.conf"
```

暗号化後は平文の`source_config`を安全に削除します。追加された全`.conf`はNixOS評価時に自動列挙され、復号後にNetworkManagerの一時プロファイルへ登録されます。自動接続は無効で、NoctaliaのNetworkパネルから接続・切断します。

暗号化後にファイルをGitへ追加し、評価します。

```bash
git add secrets/login-pin/attodesk/attodao.pbkdf2
git add secrets/noctalia/calendar-password
git add secrets/wireguard-client/attodesk/example.conf
nix flake check --no-write-lock-file
```

PIN hashが登録されると`set-login-pin`と従来の`/etc/security/login-pin`作成処理は無効になります。Noctalia passwordが登録されると、NixOS統合Home Managerだけが`credential_source = "file"`へ切り替わります。WireGuard設定が登録されると、NetworkManagerの一時プロファイルとしてNoctaliaに表示されます。

## attolapのSOPS利用

`attolap`のrecipient、ホスト別secretの作成規則、sops-nixの鍵設定は登録済みです。Age秘密鍵は`/var/lib/sops-nix/key-attolap.txt`へ配置され、`attolap`のNixOS構成にも適用済みです。`secrets/login-pin/attolap/`と`secrets/wireguard-client/attolap/`のsecretを同ホストで復号できます。

`secrets/noctalia/calendar-password`はattodeskとattolapの両recipientで暗号化済みです。両ホストとも`/run/secrets/noctalia/calendar-password`からNoctaliaへパスワードを渡します。PIN hashとWireGuard設定はホスト固有のsecretであり、それぞれ対応するホストのrecipientだけで暗号化します。

recipientを変更するときは、既存の暗号化済みファイルを`updatekeys`で更新します。

```bash
sops_bin="$(nix build --no-link --print-out-paths nixpkgs#sops)/bin/sops"
sudo SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key-attodesk.txt \
  "$sops_bin" --config .sops.yaml updatekeys --input-type binary --yes \
    secrets/noctalia/calendar-password
sudo chown attodao:users secrets/noctalia/calendar-password
chmod 0644 secrets/noctalia/calendar-password
```

更新したファイルをGitで共有した後、両ホストでbuildまたは`sudo nixos-rebuild test --flake .#<host>`を実行してからswitchします。
