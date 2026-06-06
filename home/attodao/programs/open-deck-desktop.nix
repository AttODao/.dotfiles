{ lib, pkgs, ... }:
let
  openDeckAppImagePath = ".local/share/appimages/Open-Deck.AppImage";
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
    text = ''
      set -euo pipefail

      app_dir="$HOME/.local/share/appimages"
      latest_link="$app_dir/Open-Deck.AppImage"

      mkdir -p "$app_dir"

      if ! release_json="$(curl -fsSL https://api.github.com/repos/kawa-nobu/Open-Deck-Desktop/releases/latest)"; then
        echo "warning: could not check Open-Deck Desktop latest release" >&2
        exit 0
      fi

      version="$(jq -r '.tag_name | sub("^v"; "")' <<< "$release_json")"
      asset_url="$(jq -r '.assets[] | select(.name | test("linux-x86_64\\.AppImage$")) | .browser_download_url' <<< "$release_json")"
      digest="$(jq -r '.assets[] | select(.name | test("linux-x86_64\\.AppImage$")) | .digest' <<< "$release_json")"

      if [[ -z "$version" || "$version" == "null" || -z "$asset_url" || "$asset_url" == "null" ]]; then
        echo "warning: Open-Deck Desktop x86_64 AppImage was not found in latest release" >&2
        exit 0
      fi

      target="$app_dir/Open-Deck-$version.AppImage"

      if [[ ! -f "$target" ]]; then
        tmp="$(mktemp "$app_dir/.Open-Deck-$version.XXXXXX.AppImage")"
        curl -fL "$asset_url" -o "$tmp"

        if [[ "$digest" == sha256:* ]]; then
          expected="''${digest#sha256:}"
          actual="$(sha256sum "$tmp" | cut -d' ' -f1)"
          if [[ "$actual" != "$expected" ]]; then
            rm -f "$tmp"
            echo "Open-Deck Desktop checksum mismatch for v$version" >&2
            exit 1
          fi
        fi

        chmod +x "$tmp"
        mv "$tmp" "$target"
      fi

      ln -sfn "$target" "$latest_link"

      echo "Open-Deck Desktop is ready: v$version"
    '';
  };
in
{
  home.packages = [
    updateOpenDeckDesktop
  ];

  home.activation.updateOpenDeckDesktop = lib.hm.dag.entryAfter [
    "writeBoundary"
  ] "${updateOpenDeckDesktop}/bin/update-open-deck-desktop";

  xdg.dataFile."applications/open-deck-desktop.desktop".text = ''
    [Desktop Entry]
    Name=Open-Deck
    Exec=/home/attodao/${openDeckAppImagePath} --no-sandbox %U
    Terminal=false
    Type=Application
    Icon=open_deck_desktop
    StartupWMClass=Open-Deck
    X-AppImage-Version=latest
    Comment=Open-Deck
    Categories=Network;
  '';

  xdg.dataFile."icons/hicolor/512x512/apps/open_deck_desktop.png".source = openDeckIcon;
}
