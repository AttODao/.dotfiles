{
  programs = {
    discord.enable = true;
    obs-studio.enable = true;

    prismlauncher = {
      enable = true;

      settings = {
        MinMemAlloc = 4096;
        MaxMemAlloc = 16384;
      };
    };
  };
}
