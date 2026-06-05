{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    git
    streamcontroller
    unzip
    wget
    xwayland-satellite
    zip
  ];
}
