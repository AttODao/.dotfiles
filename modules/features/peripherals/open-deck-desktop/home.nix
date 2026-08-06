{
  config,
  lib,
  pkgs,
  ...
}:
let
  openDeckAppImagePath = ".local/share/appimages/Open-Deck.AppImage";
  openDeckAppImageExec = "${config.home.homeDirectory}/${openDeckAppImagePath}";
  openDeckAppImageCommand = "${pkgs.appimage-run}/bin/appimage-run ${openDeckAppImageExec}";
  openDeckIconPath = "${config.home.homeDirectory}/.local/share/icons/hicolor/512x512/apps/open_deck_desktop.png";
  # The user-owned AppImage cannot install Electron's setuid sandbox helper.
  openDeckDesktopEntry =
    builtins.replaceStrings
      [
        "@OPEN_DECK_APPIMAGE@"
        "@OPEN_DECK_ICON@"
      ]
      [
        openDeckAppImageCommand
        openDeckIconPath
      ]
      (builtins.readFile ./open-deck-desktop.desktop);
  openDeckIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/kawa-nobu/Open-Deck-Desktop/Release/OpenDeck_App_Logo.png";
    hash = "sha256-WkBMqCSF8B6P8yNkAMt3VwzRHKaA6hhwqEn+qWavP8c=";
  };
  updateOpenDeckDesktop = pkgs.writeShellApplication {
    name = "update-open-deck-desktop";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      jq
    ];
    text = builtins.readFile ./update-open-deck-desktop.sh;
  };
in
{
  home.packages = [
    updateOpenDeckDesktop
  ];

  # Upstream only publishes a mutable AppImage, so activation updates it outside the Nix store.
  home.activation.updateOpenDeckDesktop = lib.hm.dag.entryAfter [
    "writeBoundary"
  ] "${updateOpenDeckDesktop}/bin/update-open-deck-desktop";

  xdg.dataFile."applications/open-deck-desktop.desktop".text = openDeckDesktopEntry;

  xdg.dataFile."icons/hicolor/512x512/apps/open_deck_desktop.png".source = openDeckIcon;
}
