{ pkgs, ... }:
let
  mod = "SUPER";
  noctalia = cmd: "noctalia-shell ipc call ${cmd}";
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
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,Bibata-Modern-Ice"
        "HYPRCURSOR_SIZE,24"
      ];

      monitor = [
        "HDMI-A-2,1920x1080@100,0x0,1,bitdepth,10,cm,hdr"
        "DP-1,2560x1440@143.999,1920x260,1,bitdepth,10,cm,hdr"
        "HDMI-A-1,1920x1080@60,4480x394,1"
      ];

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
        "$mod, Space, exec, ${noctalia "launcher toggle"}"
        "$mod, S, exec, ${noctalia "controlCenter toggle"}"
        "$mod, Comma, exec, ${noctalia "settings toggle"}"

        # Noctalia プラグイン
        "$mod, Tab, exec, ${noctalia "plugin:workspace-overview toggle"}"
        "$mod, F1, exec, ${noctalia "plugin:keybind-cheatsheet toggle"}"

        # クイックアクセス
        "$mod, V, exec, ${noctalia "launcher clipboard"}"
        "$mod, Period, exec, ${noctalia "launcher emoji"}"

        # カレンダー・システムモニター
        "$mod, K, exec, ${noctalia "calendar toggle"}"
        "$mod, M, exec, ${noctalia "systemMonitor toggle"}"

        # セッション・ロック
        "$mod, Escape, exec, ${noctalia "sessionMenu toggle"}"
        "$mod, L, exec, ${noctalia "lockScreen lock"}"

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
        "$mod SHIFT, S, exec, uwsm app -t service -- hyprshot -m region"
        "$mod ALT SHIFT, S, exec, uwsm app -t service -- hyprshot -m window"
        "$mod CTRL SHIFT, S, exec, uwsm app -t service -- hyprshot -m output"

        # Hyprland システム
        "$mod SHIFT, R, exec, uwsm app -t service -- hyprctl reload"
        "$mod SHIFT, E, exit,"
      ];

      bindl = [
        # 音量・輝度（Noctalia IPC 経由）
        ", XF86AudioRaiseVolume, exec, ${noctalia "volume increase"}"
        ", XF86AudioLowerVolume, exec, ${noctalia "volume decrease"}"
        ", XF86AudioMute, exec, ${noctalia "volume muteOutput"}"
        ", XF86AudioMicMute, exec, ${noctalia "volume muteInput"}"
        ", XF86MonBrightnessUp, exec, ${noctalia "brightness increase"}"
        ", XF86MonBrightnessDown, exec, ${noctalia "brightness decrease"}"

        # メディアコントロール
        ", XF86AudioPlay, exec, ${noctalia "media playPause"}"
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
        "uwsm app -t service -- noctalia-shell"
        "uwsm app -t service -- fcitx5 -r"
        "uwsm app -t service -- foot --server"
      ];

      windowrule = [
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
