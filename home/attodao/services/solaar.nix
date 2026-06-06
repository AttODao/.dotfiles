{ config, pkgs, ... }:
let
  noctaliaShell = "${config.programs.noctalia-shell.package}/bin/noctalia-shell";
  kando = "${pkgs.kando}/bin/kando";

  openNoctaliaLauncher = [
    noctaliaShell
    "ipc"
    "call"
    "launcher"
    "toggle"
  ];

  openKandoMenu = [
    kando
    "--menu"
    "default"
  ];

  closeKandoMenu = [
    kando
    "--close-menu"
  ];
in
{
  home.packages = [
    pkgs.solaar
  ];

  systemd.user.services.solaar = {
    Unit = {
      Description = "Solaar Logitech device manager";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.solaar}/bin/solaar -w hide";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile."solaar/rules.yaml".text = ''
    %YAML 1.3
    ---
    # MX Master 4 thumb gesture button. Set it to "Diverted" in Solaar's
    # Key/Button Diversion setting.
    - Key: [Mouse Gesture Button, pressed]
    - Execute: ${builtins.toJSON openNoctaliaLauncher}
    ...
    ---
    # MX Master 4 haptic button opens Kando while pressed.
    - Key: [Haptic, pressed]
    - Execute: ${builtins.toJSON openKandoMenu}
    ...
    ---
    # Releasing the haptic button selects the hovered Kando item and closes
    # the menu. Diverting the button prevents the native click, so send one.
    - Key: [Haptic, released]
    - MouseClick: [left, click]
    - Execute: ${builtins.toJSON closeKandoMenu}
    ...
  '';

  xdg.configFile."solaar/config.yaml".text = ''
    - 1.1.19
    - _NAME: MX Master 4
      _absent: [hi-res-scroll, lowres-scroll-mode, onboard_profiles, report_rate, report_rate_extended, pointer_speed, dpi_extended, speed-change, backlight,
        backlight_level, backlight_duration_hands_out, backlight_duration_powered, backlight-timed, led_control, led_zone_, rgb_control,
        rgb_zone_, brightness_control, per-key-lighting, fn-swap, persistent-remappable-keys, disable-keyboard-keys, crown-smooth, divert-crown, divert-gkeys,
        m-key-leds, mr-key-led, multiplatform, gesture2-gestures, gesture2-divert, gesture2-params, sidetone, equalizer, adc_power_management]
      _modelId: B04200000000
      _sensitive: {reprogrammable-keys: false}
      _serial: B9D5A125
      _unitId: B9D5A125
      _wpid: B042
      change-host: null
      divert-keys: {82: 0, 83: 0, 86: 0, 195: 1, 196: 0, 416: 1}
      dpi: 1000
      force-sensing: {0: 4274}
      haptic-level: 45
      hires-scroll-mode: false
      hires-smooth-invert: false
      hires-smooth-resolution: false
      reprogrammable-keys: {82: 82, 83: 83, 86: 86, 195: 195, 196: 196, 416: 416}
      scroll-ratchet: 2
      scroll-ratchet-torque: 80
      smart-shift: 41
      thumb-scroll-invert: true
      thumb-scroll-mode: false
  '';
}
