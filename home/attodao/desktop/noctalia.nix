{
  hostName,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.wl-clipboard
  ];

  xdg.configFile = {
    "noctalia/palettes/Everforest.json".source =
      "${inputs.noctalia-community-palettes}/Everforest/Everforest.json";
  };

  programs.noctalia = {
    enable = true;

    settings = {
      bar = {
        order = [ "main" ];
        main = {
          position = "top";
          thickness = 34;
          background_opacity = 0.92;
          radius = 10;
          margin_ends = 12;
          margin_edge = 6;
          padding = 12;
          widget_spacing = 6;
          shadow = true;
          reserve_space = true;
          start = [
            "launcher"
            "clock"
            "sysmon"
            "active_window"
          ];
          center = [
            "workspaces"
          ];
          end = [
            "media"
            "tray"
            "notifications"
            "clipboard"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "control-center"
            "session"
          ];
        };
      };

      shell = {
        avatar_path = "/home/attodao/.face";
        time_format = "{:%H:%M}";
        date_format = "%Y-%m-%d";
        launch_apps_as_systemd_services = true;
        panel = {
          transparency_mode = "glass";
          launcher_placement = "centered";
          control_center_placement = "attached";
          session_placement = "attached";
        };
      };

      dock = {
        enabled = true;
        position = "bottom";
        launcher_position = "start";
        active_monitor_only = false;
        show_running = true;
        show_dots = true;
        pinned =
          [
            "footclient"
            "pcmanfm"
            "dev.zed.Zed"
            "floorp"
            "thunderbird"
          ]
          ++ lib.optionals (hostName == "attodesk") [
            "open-deck"
            "org.prismlauncher.PrismLauncher"
            "anime-game-launcher"
            "honkers-railway-launcher"
          ];
      };

      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "Everforest";
      };

      weather = {
        enabled = true;
        unit = "celsius";
      };

      calendar = {
        enabled = true;
        refresh_minutes = 15;
        account.sogo = {
          type = "caldav";
          name = "AttODesk";
          color = "#3584e4";
          provider = "custom";
          server_url = "https://mail.attodao.cc/SOGo/dav/attodao@attodao.cc/Calendar/personal/";
          username = "attodao@attodao.cc";
          calendars = [ ];
        };
      };

      location = {
        address = "Toyoake, Japan";
      };

      nightlight = {
        enabled = true;
        force = true;
        temperature_day = 6500;
        temperature_night = 4500;
      };
    };
  };
}
