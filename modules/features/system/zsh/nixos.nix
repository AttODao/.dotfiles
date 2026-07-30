{ pkgs, ... }:
{
  programs.zsh.enable = true;
  users.users.attodao.shell = pkgs.zsh;
}
