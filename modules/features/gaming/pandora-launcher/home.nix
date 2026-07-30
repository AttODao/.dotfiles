{
  pkgs,
  ...
}:
let
  pandoraLauncher = pkgs.pandora-launcher.overrideAttrs (
    _finalAttrs: prevAttrs: {
      # Pandora fails to launch under the Japanese locale because its wrapper expects UTF-8 English output.
      makeWrapperArgs = prevAttrs.makeWrapperArgs ++ [
        "--set"
        "LC_ALL"
        "en_US.UTF-8"
        "--set"
        "LANG"
        "en_US.UTF-8"
      ];
    }
  );

  pandoraghCoreSource = pkgs.writeTextFile {
    name = "pandoragh-core-source";
    destination = "/share/pandoragh/pandoragh_core.py";
    text = builtins.readFile ./pandoragh_core.py;
  };

  pandoraghBin = pkgs.writeTextFile {
    name = "pandoragh-bin";
    destination = "/bin/pandoragh";
    executable = true;
    text =
      builtins.replaceStrings
        [ "@PYTHON@" "@PANDORAGH_CORE@" ]
        [ "${pkgs.python3}/bin/python3" "${pandoraghCoreSource}/share/pandoragh/pandoragh_core.py" ]
        (builtins.readFile ./pandoragh.py);
  };

  pandoragh = pkgs.symlinkJoin {
    name = "pandoragh";
    paths = [
      pandoraghBin
      pandoraghCoreSource
    ];
  };
in
{
  home.packages = [
    pandoraLauncher
    pandoragh
  ];
}
