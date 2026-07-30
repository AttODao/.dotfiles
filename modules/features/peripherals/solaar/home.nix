{ config, pkgs, ... }:
let
  yamlList = items: builtins.concatStringsSep "\n  - " (map (item: builtins.toJSON item) items);
  noctalia = "${config.programs.noctalia.package}/bin/noctalia";
  kando = "${pkgs.kando}/bin/kando";

  openNoctaliaLauncher = [
    noctalia
    "msg"
    "panel-toggle"
    "launcher"
  ];

  openKandoMenu = [
    kando
    "--menu"
    "default"
  ];

  closeKandoMenu = [
    kando
    "--close-menu"
  ];
  solaarRules =
    builtins.replaceStrings
      [
        ''"@OPEN_NOCTALIA_LAUNCHER@"''
        ''"@OPEN_KANDO_MENU@"''
        ''"@CLOSE_KANDO_MENU@"''
      ]
      [
        (yamlList openNoctaliaLauncher)
        (yamlList openKandoMenu)
        (yamlList closeKandoMenu)
      ]
      (builtins.readFile ./rules.yaml);
in
{
  home.packages = [
    pkgs.solaar
  ];

  systemd.user.services.solaar = {
    Unit = {
      Description = "Solaar Logitech device manager";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.solaar}/bin/solaar -w hide";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile."solaar/rules.yaml".text = solaarRules;

  xdg.configFile."solaar/config.yaml".source = ./config.yaml;
}
