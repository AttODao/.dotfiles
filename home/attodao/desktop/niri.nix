{
  config,
  hostName,
  lib,
  pkgs,
  ...
}:
let
  noctalia =
    cmd:
    [
      "noctalia"
      "msg"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in
{
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "noctalia" ]; }
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

    window-rules = lib.optionals (hostName == "attodesk") [
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
      "Mod+Space".action.spawn = noctalia "panel-toggle launcher";
      "Mod+S".action.spawn = noctalia "panel-toggle control-center";
      "Mod+Comma".action.spawn = noctalia "settings-toggle";

      # クイックアクセス
      "Mod+V".action.spawn = noctalia "panel-toggle clipboard";
      "Mod+Period".action.spawn = noctalia "panel-toggle launcher /emo ";

      # カレンダー・システムモニター
      "Mod+K".action.spawn = noctalia "panel-toggle control-center calendar";
      "Mod+M".action.spawn = noctalia "panel-toggle control-center system";

      # セッション・ロック
      "Mod+Escape".action.spawn = noctalia "panel-toggle session";
      "Mod+L".action.spawn = noctalia "session lock";

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
      "XF86AudioRaiseVolume".action.spawn = noctalia "volume-up";
      "XF86AudioLowerVolume".action.spawn = noctalia "volume-down";
      "XF86AudioMute".action.spawn = noctalia "volume-mute";
      "XF86AudioMicMute".action.spawn = noctalia "microphone-mute";
      "XF86MonBrightnessUp".action.spawn = noctalia "brightness-up";
      "XF86MonBrightnessDown".action.spawn = noctalia "brightness-down";

      # メディアコントロール
      "XF86AudioPlay".action.spawn = noctalia "media toggle";
      "XF86AudioNext".action.spawn = noctalia "media next";
      "XF86AudioPrev".action.spawn = noctalia "media previous";

      # Niri システム
      "Mod+Shift+E".action = quit;
      "Mod+Shift+R".action = spawn-sh "niri msg action load-config-file";
    };

    outputs = lib.mkIf (hostName == "attodesk") {
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
