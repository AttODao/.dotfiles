{
  hostName,
  lib,
  pkgs,
  ...
}:
let
  pandoraLauncher = pkgs.pandora-launcher.overrideAttrs (_finalAttrs: prevAttrs: {
    makeWrapperArgs = prevAttrs.makeWrapperArgs ++ [
      "--set"
      "LC_ALL"
      "en_US.UTF-8"
      "--set"
      "LANG"
      "en_US.UTF-8"
    ];
  });

  pandoraghCoreSource = pkgs.writeTextFile {
    name = "pandoragh-core-source";
    destination = "/share/pandoragh/pandoragh_core.py";
    text = builtins.readFile ./pandoragh/pandoragh_core.py;
  };

  pandoraghBin = pkgs.writeTextFile {
    name = "pandoragh-bin";
    destination = "/bin/pandoragh";
    executable = true;
    text = builtins.replaceStrings
      [ "@PYTHON@" "@PANDORAGH_CORE@" ]
      [ "${pkgs.python3}/bin/python3" "${pandoraghCoreSource}/share/pandoragh/pandoragh_core.py" ]
      (
      builtins.readFile ./pandoragh/pandoragh.py
      );
  };

  pandoragh = pkgs.symlinkJoin {
    name = "pandoragh";
    paths = [
      pandoraghBin
      pandoraghCoreSource
    ];
  };
in
lib.mkIf (hostName == "attodesk") {
  home.packages = [
    pandoraLauncher
    pandoragh
  ];
}
