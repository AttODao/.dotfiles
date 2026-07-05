{
  config,
  ...
}:
{
  programs = {
    discord.enable = true;
    obs-studio.enable = true;

    zed-editor = {
      enable = true;
      userSettings.autosave = "on_focus_change";
    };

    prismlauncher = {
      enable = true;

      settings = {
        MinMemAlloc = 4096;
        MaxMemAlloc = 16384;
      };
    };
  };

  systemd.user.services.discord = {
    Unit = {
      Description = "Discord desktop client";
      After = [
        "graphical-session.target"
        "fcitx5.service"
      ];
    };

    Service = {
      ExecStart = "${config.programs.discord.package}/bin/discord --start-minimized";
      Restart = "on-failure";
      RestartSec = 3;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
