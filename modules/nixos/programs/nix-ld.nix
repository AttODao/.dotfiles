{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      stdenv.cc.cc
      openssl
      zlib
      zstd
      curl
      libxml2
      libcap
    ];
  };
}
