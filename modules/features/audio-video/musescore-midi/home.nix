{
  pkgs,
  ...
}:
let
  aconnect = "${pkgs.alsa-utils}/bin/aconnect";
  awk = "${pkgs.gawk}/bin/awk";
  sleep = "${pkgs.coreutils}/bin/sleep";

  midiBridge = pkgs.writeShellScript "musescore-midi-bridge" ''
    set -u

    find_port() {
      LC_ALL=C ${aconnect} -l 2>/dev/null | ${awk} -v name="$1" '
        /^client [0-9]+:/ {
          client = $2
          sub(/:$/, "", client)
        }
        /^[[:space:]]+[0-9]+ / && index($0, name) {
          print client ":" $1
          exit
        }
      '
    }

    while :; do
      input_port="$(find_port "KeyLab mkII 61 MIDI")"
      bridge_port="$(find_port "Midi Through Port-0")"

      if [ -n "$input_port" ] && [ -n "$bridge_port" ]; then
        ${aconnect} "$input_port" "$bridge_port" >/dev/null 2>&1 || true
      fi

      ${sleep} 2
    done
  '';
in
{
  home.packages = [
    pkgs.alsa-utils
  ];

  systemd.user.services.musescore-midi = {
    Unit = {
      Description = "Connect the Arturia KeyLab MIDI input";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = midiBridge;
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
