{
  hostName,
  lib,
  pkgs,
  ...
}:
let
  python3WithPackages = pkgs.python3.withPackages (
    pythonPackages: with pythonPackages; [
      colorama
      icmplib
      ntplib
      pip
      pytz
      requests
      urllib3
    ]
  );
in
{
  environment.systemPackages =
    (with pkgs; [
      codex
      curl
      fastfetch
      git
      python3WithPackages
      seahorse
      unzip
      wget
      zip
    ])
    ++ lib.optionals (hostName == "attodesk") [
      pkgs.streamcontroller
    ];
}
