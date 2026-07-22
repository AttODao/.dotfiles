{
  config,
  hostName,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  recordingsDirectory = "${config.xdg.userDirs.videos}/Recordings";
  osConfig = config.osConfig or null;
  gpuScreenRecorder =
    if osConfig != null then osConfig.programs.gpu-screen-recorder.package else pkgs.gpu-screen-recorder;
  renderScript =
    scriptPath: from: to:
    builtins.replaceStrings from to (builtins.readFile scriptPath);
  recordingToX = pkgs.writeShellApplication {
    name = "recording-to-x";
    runtimeInputs = with pkgs; [
      coreutils
      ffmpeg-full
    ];
    text = renderScript ./noctalia/recording-to-x.sh
      [ "@RECORDINGS_DIRECTORY@" ]
      [ (lib.escapeShellArg recordingsDirectory) ];
  };
  gpuScreenRecorderAutoX = pkgs.writeShellApplication {
    name = "gpu-screen-recorder";
    runtimeInputs = [ pkgs.coreutils ];
    text = renderScript ./noctalia/gpu-screen-recorder-auto-x.sh
      [ "@GPU_SCREEN_RECORDER@" "@RECORDING_TO_X@" "@RECORDINGS_DIRECTORY@" ]
      [
        (lib.escapeShellArg "${gpuScreenRecorder}/bin/gpu-screen-recorder")
        (lib.escapeShellArg "${recordingToX}/bin/recording-to-x")
        (lib.escapeShellArg recordingsDirectory)
      ];
  };
  videoSource = if hostName == "attodesk" then "focused" else "portal";
  videoCodec = if hostName == "attodesk" then "hevc_hdr" else "h264";
in
{
  home.packages = [
    pkgs.wl-clipboard
  ]
  ++ lib.optionals (hostName == "attodesk") [
    # Shadow the recorder binary so Noctalia auto-transcodes finished recordings.
    gpuScreenRecorderAutoX
    recordingToX
  ]
  ++ lib.optionals (hostName != "attodesk") [
    gpuScreenRecorder
  ];

  home.activation.ensureNoctaliaRecordingsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.coreutils}/bin/install -d -m 755 ${lib.escapeShellArg recordingsDirectory}
  '';

  xdg.configFile = {
    "noctalia/palettes/Everforest.json".source =
      "${inputs.noctalia-community-palettes}/Everforest/Everforest.json";
  };

  programs.noctalia = {
    enable = true;

    settings = {
      plugins.enabled = [ "noctalia/screen_recorder" ];
      plugin_settings."noctalia/screen_recorder" = {
        directory = recordingsDirectory;
        video_source = videoSource;
        video_codec = videoCodec;
      };

      widget.screen_recorder = {
        type = "noctalia/screen_recorder:recorder";
      };

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
            "screen_recorder"
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
            "discord"
            "open-deck-desktop"
          ]
          ++ lib.optionals (hostName == "attodesk") [
            "com.moulberry.pandoralauncher"
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
          name = "AttODao";
          color = "#3584e4";
          provider = "custom";
          server_url = "https://mail.attodao.cc/radicale/";
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
