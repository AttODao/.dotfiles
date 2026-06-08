{
  inputs,
  pkgs,
  ...
}:
let
  noctaliaPluginSource = "https://github.com/noctalia-dev/noctalia-plugins";
in
{
  home.packages = [
    pkgs.wl-clipboard
  ];

  xdg.configFile = {
    "noctalia/colorschemes/Everforest/Everforest.json".source =
      "${inputs.noctalia-community-palettes}/Everforest/Everforest.json";
  };

  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      calendarSupport = true;
    };

    settings = {
      bar = {
        position = "top";
        density = "default";
        widgets = {
          left = [
            { id = "Launcher"; }
            { id = "plugin:keybind-cheatsheet"; }
            { id = "Clock"; }
            { id = "SystemMonitor"; }
            { id = "ActiveWindow"; }
            { id = "MediaMini"; }
          ];
          center = [
            { id = "Workspace"; }
            { id = "plugin:workspace-overview"; }
          ];
          right = [
            { id = "Tray"; }
            { id = "NotificationHistory"; }
            { id = "Battery"; }
            { id = "Volume"; }
            { id = "Brightness"; }
            { id = "ControlCenter"; }
          ];
        };
      };

      general.avatarImage = "/home/attodao/.face";

      dock = {
        onlySameOutput = false;
        showLauncherIcon = true;
        launcherPosition = "start";
        launcherUseDistroLogo = true;
        groupApps = true;
        groupClickAction = "cycle";
        groupIndicatorStyle = "dots";
        pinnedApps = [
          "Foot Client"
          "PCManFM"
          "Zed"
          "Floorp"
          "Open-Deck"
          "Prism Launcher"
          "An Anime Game Launcher"
          "The Honkers Railway Launcher"
        ];
      };

      appLauncher = {
        customLaunchPrefixEnabled = true;
        customLaunchPrefix = "uwsm app -t service --";
      };

      location = {
        name = "Toyoake, Japan";
        use12hourFormat = false;
        useFahrenheit = false;
      };

      nightLight = {
        enabled = true;
        forced = true;
        autoSchedule = false;
        nightTemp = "4500";
        dayTemp = "6500";
      };

      colorSchemes = {
        predefinedScheme = "Everforest";
        darkMode = true;
        schedulingMode = "off";
      };

      plugins = {
        autoUpdate = false;
        notifyUpdates = true;
      };
    };

    plugins = {
      sources = [
        {
          enabled = true;
          name = "Noctalia Plugins";
          url = noctaliaPluginSource;
        }
      ];
      states = {
        workspace-overview = {
          enabled = true;
          sourceUrl = noctaliaPluginSource;
        };
        keybind-cheatsheet = {
          enabled = true;
          sourceUrl = noctaliaPluginSource;
        };
      };
      version = 2;
    };

    pluginSettings = {
      keybind-cheatsheet = {
        windowWidth = 1400;
        windowHeight = 850;
        autoHeight = true;
        columnCount = 3;
        modKeyVariable = "$mod";
        hyprlandConfigPath = "~/.config/hypr/hyprland.conf";
        niriConfigPath = "~/.config/niri/config.kdl";
        hyprlandParserMode = "conf";
        mergeSequentialBinds = true;
        showUndescribedBinds = true;
        splitLargeWorkspaceCategory = true;
        workspaceSplitThreshold = 12;
      };

      workspace-overview = { };
    };
  };
}
