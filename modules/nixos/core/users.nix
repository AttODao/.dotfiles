{ pkgs, ... }:
{
  users.users.attodao = {
    isNormalUser = true;
    description = "AttODao";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "audio"
    ];
    shell = pkgs.zsh;
  };
}
