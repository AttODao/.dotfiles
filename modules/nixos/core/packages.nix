{
  hostName,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages =
    (with pkgs; [
      curl
      fastfetch
      git
      seahorse
      unzip
      wget
      zip
    ])
    ++ lib.optionals (hostName == "attodesk") [
      pkgs.streamcontroller
    ];
}
