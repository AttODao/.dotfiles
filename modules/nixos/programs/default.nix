{
  imports = [
    ./nix-ld.nix
    ./steam.nix
    ./pipeasio.nix
  ];

  programs = {
    anime-game-launcher.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    honkers-railway-launcher.enable = true;
    zsh.enable = true;
  };
}
