{
  config,
  ...
}:
{
  home = {
    username = "attodao";
    homeDirectory = "/home/${config.home.username}";

    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
