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
      "uinput"
      "audio"
    ];
    shell = pkgs.zsh;
  };
}
