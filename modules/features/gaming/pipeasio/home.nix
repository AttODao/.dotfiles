{ lib, pkgs, ... }:
let
  pipeasio = pkgs.callPackage ./package.nix { };
  registerSteamPrefixes = pkgs.writeTextFile {
    name = "pipeasio-register-steam-prefixes";
    destination = "/bin/pipeasio-register-steam-prefixes";
    executable = true;
    text =
      builtins.replaceStrings
        [ "@PYTHON@" "@WINE@" "@PIPEASIO_REGISTER@" ]
        [
          "${pkgs.python3}/bin/python3"
          "${pkgs.wineWow64Packages.stable}/bin/wine"
          "${pipeasio}/bin/pipeasio-register"
        ]
        (builtins.readFile ./register-steam-prefixes.py);
  };
in
{
  # Existing Proton prefixes need registry entries that package installation cannot create.
  home.packages = [
    registerSteamPrefixes
  ];

  home.activation.registerPipeasioSteamPrefixes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${registerSteamPrefixes}/bin/pipeasio-register-steam-prefixes --skip-registered
  '';
}
