{ lib, pkgs, ... }:
let
  openDeckAppImagePath = ".local/share/appimages/Open-Deck.AppImage";
  openDeckAppImageExec = "/home/attodao/${openDeckAppImagePath}";
  openDeckIconPath = "/home/attodao/.local/share/icons/hicolor/512x512/apps/open_deck_desktop.png";
  openDeckDesktopEntry = builtins.replaceStrings
    [
      "@OPEN_DECK_APPIMAGE@"
      "@OPEN_DECK_ICON@"
    ]
    [
      openDeckAppImageExec
      openDeckIconPath
    ]
    (builtins.readFile ./open-deck-desktop/open-deck-desktop.desktop);
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
    text = builtins.readFile ./open-deck-desktop/update-open-deck-desktop.sh;
  };
in
{
  home.packages = [
    updateOpenDeckDesktop
  ];

  home.activation.updateOpenDeckDesktop = lib.hm.dag.entryAfter [
    "writeBoundary"
  ] "${updateOpenDeckDesktop}/bin/update-open-deck-desktop";

  xdg.dataFile."applications/open-deck-desktop.desktop".text = openDeckDesktopEntry;

  xdg.dataFile."icons/hicolor/512x512/apps/open_deck_desktop.png".source = openDeckIcon;
}
