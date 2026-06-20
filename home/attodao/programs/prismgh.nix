{
  config,
  lib,
  pkgs,
  ...
}:
let
  prismgh = pkgs.writeTextFile {
    name = "prismgh";
    destination = "/bin/prismgh";
    executable = true;
    text = builtins.replaceStrings [ "@PYTHON@" ] [ "${pkgs.python3}/bin/python3" ] (
      builtins.readFile ./prismgh/prismgh.py
    );
  };
in
lib.mkIf config.programs.prismlauncher.enable {
  home.packages = [
    prismgh
  ];
}
