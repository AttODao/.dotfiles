{ config, pkgs, ... }:
let
  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in
{
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
      {
        command = [
          "xwayland-satellite"
          ":0"
        ];
      }
      {
        command = [
          "fcitx5"
          "-r"
        ];
      }
      {
        command = [
          "foot"
          "--server"
        ];
      }
    ];

    hotkey-overlay.skip-at-startup = true;

    window-rules = [
      {
        matches = [
          { title = "Kando Menu"; }
        ];

        open-floating = true;

        focus-ring.enable = false;
        border.enable = false;
        shadow.enable = false;

        default-floating-position = {
          x = 0;
          y = 0;
          relative-to = "top-left";
        };
      }
    ];

    binds = with config.lib.niri.actions; {
      # アプリ起動
      "Mod+Return".action = spawn "footclient";
      "Mod+E".action = spawn "pcmanfm";

      # Noctalia コア
      "Mod+Space".action.spawn = noctalia "launcher toggle";
      "Mod+S".action.spawn = noctalia "controlCenter toggle";
      "Mod+Comma".action.spawn = noctalia "settings toggle";

      # Noctalia プラグイン
      "Mod+F1".action.spawn = noctalia "plugin:keybind-cheatsheet toggle";

      # クイックアクセス
      "Mod+V".action.spawn = noctalia "launcher clipboard";
      "Mod+Period".action.spawn = noctalia "launcher emoji";

      # カレンダー・システムモニター
      "Mod+K".action.spawn = noctalia "calendar toggle";
      "Mod+M".action.spawn = noctalia "systemMonitor toggle";

      # セッション・ロック
      "Mod+Escape".action.spawn = noctalia "sessionMenu toggle";
      "Mod+L".action.spawn = noctalia "lockScreen lock";

      # ウィンドウ操作
      "Mod+Q".action = close-window;
      "Mod+F".action = maximize-column;
      "Mod+Shift+F".action = fullscreen-window;
      "Mod+C".action = center-column;
      "Mod+R".action = switch-preset-column-width;

      # フォーカス移動
      "Mod+Left".action = focus-column-left;
      "Mod+Right".action = focus-column-right;
      "Mod+Up".action = focus-window-up;
      "Mod+Down".action = focus-window-down;

      # ウィンドウ移動
      "Mod+Shift+Left".action = move-column-left;
      "Mod+Shift+Right".action = move-column-right;
      "Mod+Shift+Up".action = move-window-up;
      "Mod+Shift+Down".action = move-window-down;

      # ワークスペース
      "Mod+WheelScrollDown" = {
        cooldown-ms = 150;
        action = focus-workspace-down;
      };
      "Mod+WheelScrollUp" = {
        cooldown-ms = 150;
        action = focus-workspace-up;
      };
      "Mod+WheelScrollRight".action = focus-column-right;
      "Mod+WheelScrollLeft".action = focus-column-left;

      # スクリーンショット
      "Mod+Shift+S".action = spawn-sh "niri msg action screenshot";
      "Mod+Alt+Shift+S".action = spawn-sh "niri msg action screenshot-window";
      "Mod+Ctrl+Shift+S".action = spawn-sh "niri msg action screenshot-screen";

      # 音量・輝度（Noctalia IPC 経由）
      "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
      "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
      "XF86AudioMute".action.spawn = noctalia "volume muteOutput";
      "XF86AudioMicMute".action.spawn = noctalia "volume muteInput";
      "XF86MonBrightnessUp".action.spawn = noctalia "brightness increase";
      "XF86MonBrightnessDown".action.spawn = noctalia "brightness decrease";

      # メディアコントロール
      "XF86AudioPlay".action.spawn = noctalia "media playPause";
      "XF86AudioNext".action.spawn = noctalia "media next";
      "XF86AudioPrev".action.spawn = noctalia "media previous";

      # Niri システム
      "Mod+Shift+E".action = quit;
      "Mod+Shift+R".action = spawn-sh "niri msg action load-config-file";
    };

    outputs = {
      "HDMI-A-2" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 100.0;
        };

        position = {
          x = 0;
          y = 0;
        };
      };

      "DP-1" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 143.999;
        };

        position = {
          x = 1920;
          y = 260;
        };
      };

      "HDMI-A-1" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
        };

        position = {
          x = 4480;
          y = 394;
        };
      };
    };
  };
}
