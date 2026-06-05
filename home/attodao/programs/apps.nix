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
}
