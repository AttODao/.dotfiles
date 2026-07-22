{
  hostName,
  lib,
  pkgs,
  ...
}:
let
  mod = "SUPER";
  cursorTheme = "Yanfei-Cursors";
  cursorSize = "48";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  noctalia = cmd: "noctalia msg ${cmd}";
  screenshotDirectory =
    if hostName == "attodesk" then
      "/mnt/hdd1/Pictures/Screenshots"
    else
      "/home/attodao/Pictures/Screenshots";
in
{
  home.packages = [
    pkgs.hyprshot
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    # Home Manager master / stateVersion 26.05 以降でも、Lua ではなく
    # ~/.config/hypr/hyprland.conf を生成する。
    configType = "hyprlang";

    systemd.enable = false;
    xwayland.enable = true;

    settings = {
      "$mod" = mod;

      env = [
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "XCURSOR_THEME,${cursorTheme}"
        "XCURSOR_SIZE,${cursorSize}"
        "HYPRCURSOR_THEME,${cursorTheme}"
        "HYPRCURSOR_SIZE,${cursorSize}"
      ];

      monitor =
        if hostName == "attodesk" then
          [
            "HDMI-A-2,1920x1080@100,0x0,1,bitdepth,10,cm,hdr"
            "DP-1,2560x1440@143.999,1920x260,1,bitdepth,10,cm,hdr"
            "HDMI-A-1,1920x1080@60,4480x394,1"
          ]
        else
          [ ",preferred,auto,1" ];

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgba(a7c080ee) rgba(83c092ee) 45deg";
        "col.inactive_border" = "rgba(3c4841aa)";
        resize_on_border = true;
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 0.96;
        fullscreen_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 18;
          render_power = 3;
          color = "rgba(0b1010aa)";
          color_inactive = "rgba(0b101066)";
          offset = "0 3";
          scale = 0.98;
        };

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          noise = 0.0117;
          contrast = 0.95;
          brightness = 0.82;
          vibrancy = 0.16;
          new_optimizations = true;
          ignore_opacity = true;
          xray = false;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
        ];
        animation = [
          "windows,1,4,easeOutQuint,popin 85%"
          "windowsOut,1,3,easeInOutCubic,popin 85%"
          "border,1,5,easeOutQuint"
          "fade,1,4,easeOutQuint"
          "workspaces,1,4,easeOutQuint,slide"
        ];
      };

      input = {
        special_fallthrough = true;
        focus_on_close = 1;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
      };

      bind = [
        # アプリ起動
        "$mod, Return, exec, uwsm app -t service -- footclient"
        "$mod, E, exec, uwsm app -t service -- pcmanfm"

        # Noctalia コア
        "$mod, Space, exec, ${noctalia "panel-toggle launcher"}"
        "$mod, S, exec, ${noctalia "panel-toggle control-center"}"
        "$mod, Comma, exec, ${noctalia "settings-toggle"}"

        # クイックアクセス
        "$mod, V, exec, ${noctalia "panel-toggle clipboard"}"
        "$mod, Period, exec, ${noctalia "panel-toggle launcher /emo "}"

        # カレンダー・システムモニター
        "$mod, K, exec, ${noctalia "panel-toggle control-center calendar"}"
        "$mod, M, exec, ${noctalia "panel-toggle control-center system"}"

        # セッション・ロック
        "$mod, Escape, exec, ${noctalia "panel-toggle session"}"
        "$mod, L, exec, ${noctalia "session lock"}"

        # 録画
        "$mod SHIFT, D, exec, ${noctalia "plugin noctalia/screen_recorder:service all toggle"}"

        # ウィンドウ操作
        "$mod, Q, killactive,"
        "$mod, F, fullscreen, 1"
        "$mod SHIFT, F, fullscreen, 0"
        "$mod, C, centerwindow,"
        "$mod, R, togglefloating,"

        # フォーカス移動
        "$mod, Left, movefocus, l"
        "$mod, Right, movefocus, r"
        "$mod, Up, movefocus, u"
        "$mod, Down, movefocus, d"

        # ウィンドウ移動
        "$mod SHIFT, Left, movewindow, l"
        "$mod SHIFT, Right, movewindow, r"
        "$mod SHIFT, Up, movewindow, u"
        "$mod SHIFT, Down, movewindow, d"

        # ワークスペース
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # スクリーンショット
        # Keep the frozen preview; hyprshot/grim still omits the cursor.
        "$mod SHIFT, S, exec, uwsm app -t service -- hyprshot --freeze -m region -o ${screenshotDirectory}"
        "$mod ALT SHIFT, S, exec, uwsm app -t service -- hyprshot --freeze -m window -o ${screenshotDirectory}"
        "$mod CTRL SHIFT, S, exec, uwsm app -t service -- hyprshot --freeze -m output -o ${screenshotDirectory}"

        # Hyprland システム
        "$mod SHIFT, R, exec, uwsm app -t service -- hyprctl reload"
        "$mod SHIFT, E, exit,"
      ];

      bindl = [
        # 音量・輝度（Noctalia IPC 経由）
        ", XF86AudioRaiseVolume, exec, ${noctalia "volume-up"}"
        ", XF86AudioLowerVolume, exec, ${noctalia "volume-down"}"
        ", XF86AudioMute, exec, ${noctalia "volume-mute"}"
        ", XF86AudioMicMute, exec, ${noctalia "microphone-mute"}"
        ", XF86MonBrightnessUp, exec, ${noctalia "brightness-up"}"
        ", XF86MonBrightnessDown, exec, ${noctalia "brightness-down"}"

        # メディアコントロール
        ", XF86AudioPlay, exec, ${noctalia "media toggle"}"
        ", XF86AudioNext, exec, ${noctalia "media next"}"
        ", XF86AudioPrev, exec, ${noctalia "media previous"}"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      cursor = {
        enable_hyprcursor = true;
        no_hardware_cursors = true;
      };

      exec-once = [
        # Start the portal and fcitx5 before Noctalia so screencast and IME
        # are ready as soon as the session appears.
        "${systemctl} --user start fcitx5-daemon.service xdg-desktop-portal.service xdg-desktop-portal-gtk.service xdg-desktop-portal-hyprland.service"
        "uwsm app -t service -- noctalia"
        "uwsm app -t service -- foot --server"
      ];

      windowrule = lib.optionals (hostName == "attodesk") [
        "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, float on"
        "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, pin on"
        "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, move 0 0"
        "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, size 100% 100%"
        "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, border_size 0"
        "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, rounding 0"
        "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, no_anim on"
        "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, no_blur on"
        "match:class ^menu\\.kando\\.Kando$, match:title ^Kando Menu$, opaque on"
      ];
    };
  };
}
