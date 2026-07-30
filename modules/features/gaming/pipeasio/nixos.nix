{
  config,
  lib,
  pkgs,
  ...
}:
let
  pipeasio = pkgs.callPackage ./package.nix { };
in
lib.mkMerge [
  {
    environment.systemPackages = [ pipeasio ];
  }
  (lib.mkIf config.programs.steam.enable {
    programs.steam.package = pkgs.steam.override {
      extraEnv = {
        # Proton only discovers the Unix bridge when it is added to WINEDLLPATH.
        WINEDLLPATH = "${pipeasio}/lib/wine";
      };
    };
  })
]
