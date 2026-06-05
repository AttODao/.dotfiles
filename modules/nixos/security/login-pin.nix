{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.attodao.loginPin;

  checkLoginPin = pkgs.writeTextFile {
    name = "check-login-pin";
    destination = "/bin/check-login-pin";
    executable = true;
    text = ''
      #!${pkgs.python3}/bin/python3

      import base64
      import hashlib
      import hmac
      import os
      import re
      import sys
      from pathlib import Path

      ALLOWED_USERS = ${builtins.toJSON cfg.users}

      user = os.environ.get("PAM_USER", "")

      if user not in ALLOWED_USERS:
          sys.exit(1)

      raw = sys.stdin.buffer.read(512)
      pin = raw.split(b"\0", 1)[0].decode("utf-8", "ignore").strip()

      if not re.fullmatch(r"\d{6}", pin):
          sys.exit(1)

      path = Path("/etc/security/login-pin") / f"{user}.pbkdf2"

      try:
          stored = path.read_text().strip()
          algo, iterations_s, salt_b64, hash_b64 = stored.split("$", 3)
      except Exception:
          sys.exit(1)

      if algo != "pbkdf2_sha256":
          sys.exit(1)

      try:
          iterations = int(iterations_s)
          salt = base64.b64decode(salt_b64)
          expected = base64.b64decode(hash_b64)
      except Exception:
          sys.exit(1)

      actual = hashlib.pbkdf2_hmac(
          "sha256",
          pin.encode("utf-8"),
          salt,
          iterations,
      )

      if hmac.compare_digest(actual, expected):
          sys.exit(0)

      sys.exit(1)
    '';
  };

  setLoginPin = pkgs.writeShellApplication {
    name = "set-login-pin";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.python3
    ];

    text = ''
      set -eu

      user="''${1:-attodao}"

      allowed_users=" ${lib.concatStringsSep " " cfg.users} "

      case "$allowed_users" in
        *" $user "*) ;;
        *)
          echo "error: user '$user' is not enabled for login PIN" >&2
          exit 1
          ;;
      esac

      if [ "$(id -u)" -ne 0 ]; then
        echo "error: run as root, for example: sudo set-login-pin $user" >&2
        exit 1
      fi

      printf "New 6-digit PIN for %s: " "$user" >&2
      read -r -s pin1
      printf "\nConfirm 6-digit PIN: " >&2
      read -r -s pin2
      printf "\n" >&2

      if [ "$pin1" != "$pin2" ]; then
        echo "error: PINs do not match" >&2
        exit 1
      fi

      case "$pin1" in
        [0-9][0-9][0-9][0-9][0-9][0-9]) ;;
        *)
          echo "error: PIN must be exactly 6 digits" >&2
          exit 1
          ;;
      esac

      install -d -m 0700 -o root -g root /etc/security/login-pin

      hash="$(${pkgs.python3}/bin/python3 - "$pin1" <<'PY'
      import base64
      import hashlib
      import os
      import sys

      pin = sys.argv[1]
      iterations = 200000
      salt = os.urandom(16)
      digest = hashlib.pbkdf2_hmac(
          "sha256",
          pin.encode("utf-8"),
          salt,
          iterations,
      )

      print(
          "pbkdf2_sha256"
          + "$"
          + str(iterations)
          + "$"
          + base64.b64encode(salt).decode("ascii")
          + "$"
          + base64.b64encode(digest).decode("ascii")
      )
      PY
      )"

      tmp="$(mktemp)"
      printf "%s\n" "$hash" > "$tmp"
      install -m 0600 -o root -g root "$tmp" "/etc/security/login-pin/$user.pbkdf2"
      rm -f "$tmp"

      echo "PIN updated for $user"
    '';
  };

  pinPamFor = serviceName: {
    unixAuth = cfg.allowPasswordFallback;

    rules.auth.login-pin = {
      order = config.security.pam.services.${serviceName}.rules.auth.unix.order - 10;
      control = "sufficient";
      modulePath = "${config.security.pam.package}/lib/security/pam_exec.so";
      args = [
        "quiet"
        "expose_authtok"
        "${checkLoginPin}/bin/check-login-pin"
      ];
    };
  };
in
{
  options.attodao.loginPin = {
    enable = lib.mkEnableOption "6-digit PIN authentication for selected PAM services";

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "attodao" ];
      description = "Users allowed to authenticate with a 6-digit PIN.";
    };

    services = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "greetd" ];
      description = "PAM service names where the PIN rule should be enabled.";
    };

    allowPasswordFallback = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether the normal Unix password remains valid if PIN authentication fails.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      setLoginPin
    ];

    system.activationScripts.loginPinDir = ''
      install -d -m 0700 -o root -g root /etc/security/login-pin
    '';

    security.pam.services = lib.genAttrs cfg.services pinPamFor;
  };
}
