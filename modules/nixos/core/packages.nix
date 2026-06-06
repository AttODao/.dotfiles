{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    fastfetch
    git
    seahorse
    streamcontroller
    unzip
    wget
    zip
  ];
}
