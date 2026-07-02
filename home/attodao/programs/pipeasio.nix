{ lib, pkgs, ... }:
let
  registerSteamPrefixes = pkgs.writeTextFile {
    name = "pipeasio-register-steam-prefixes";
    destination = "/bin/pipeasio-register-steam-prefixes";
    executable = true;
    text = builtins.replaceStrings
      [ "@PYTHON@" ]
      [ "${pkgs.python3}/bin/python3" ]
      (builtins.readFile ./pipeasio/register-steam-prefixes.py);
  };
in
{
  # Register PipeASIO for already-installed Steam Proton prefixes right away,
  # and keep a manual command around for future reruns.
  home.packages = [
    registerSteamPrefixes
  ];

  home.activation.registerPipeasioSteamPrefixes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${registerSteamPrefixes}/bin/pipeasio-register-steam-prefixes
  '';
}
