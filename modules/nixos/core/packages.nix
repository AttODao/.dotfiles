{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    git
    seahorse
    streamcontroller
    unzip
    wget
    zip
  ];
}
