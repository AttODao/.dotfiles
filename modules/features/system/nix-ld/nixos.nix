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

      # Native libraries loaded dynamically by LWJGL/GLFW.
      libglvnd
      mesa
      wayland
      libxkbcommon
      libdecor
      libx11
      libxcursor
      libxi
      libxinerama
      libxrandr
      libxrender
      libxcb

      # Audio backends loaded dynamically by OpenAL.
      pipewire
      libpulseaudio
      alsa-lib

      # Minecraft narrator backend.
      flite
    ];
  };
}
