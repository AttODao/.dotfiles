{ lib, pkgs, ... }:
let
  steamExec = ''/bin/sh -c "sleep 1; exec steam \"\$@\"" steam'';
  pcmanfmIcon = pkgs.runCommandLocal "pcmanfm-icon.png" {
    nativeBuildInputs = [ pkgs.librsvg ];
  } ''
    rsvg-convert -w 256 -h 256 \
      ${pkgs.papirus-icon-theme}/share/icons/Papirus/64x64/apps/system-file-manager.svg \
      > $out
  '';
in
{
  xdg = {
    enable = true;

    dataFile."icons/hicolor/256x256/apps/pcmanfm.png".source = pcmanfmIcon;

    dataFile."applications/pcmanfm.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=PCMan File Manager
      Name[ja]=PCMan ファイルマネージャ
      GenericName=File Manager
      GenericName[ja]=ファイルマネージャ
      Exec=${pkgs.pcmanfm}/bin/pcmanfm %U
      Icon=pcmanfm
      Terminal=false
      StartupNotify=true
      Categories=GTK;System;Core;FileTools;FileManager;
      MimeType=inode/directory;x-directory/normal;
    '';

    dataFile."applications/steam.desktop".text = ''
      [Desktop Entry]
      Name=Steam
      Comment=Application for managing and playing games on Steam
      Comment[ja]=Steam 上でゲームを管理＆プレイするためのアプリケーション
      Exec=${steamExec} %U
      Icon=steam
      Terminal=false
      Type=Application
      Categories=Network;FileTransfer;Game;
      MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
      Actions=Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;
      PrefersNonDefaultGPU=true
      X-KDE-RunOnDiscreteGpu=true

      [Desktop Action Store]
      Name=Store
      Name[ja]=ストア
      Exec=${steamExec} steam://store

      [Desktop Action Community]
      Name=Community
      Name[ja]=コミュニティ
      Exec=${steamExec} steam://url/CommunityHome/

      [Desktop Action Library]
      Name=Library
      Name[ja]=ライブラリ
      Exec=${steamExec} steam://open/games

      [Desktop Action Servers]
      Name=Servers
      Name[ja]=サーバー
      Exec=${steamExec} steam://open/servers

      [Desktop Action Screenshots]
      Name=Screenshots
      Name[ja]=スクリーンショット
      Exec=${steamExec} steam://open/screenshots

      [Desktop Action News]
      Name=News
      Name[ja]=ニュース
      Exec=${steamExec} steam://openurl/https://store.steampowered.com/news

      [Desktop Action Settings]
      Name=Settings
      Name[ja]=設定
      Exec=${steamExec} steam://open/settings

      [Desktop Action BigPicture]
      Name=Big Picture
      Exec=${steamExec} steam://open/bigpicture

      [Desktop Action Friends]
      Name=Friends
      Name[ja]=フレンド
      Exec=${steamExec} steam://open/friends
    '';

    dataFile."applications/protonup-qt.desktop".source =
      pkgs.runCommandLocal "protonup-qt-desktop-entry" { } ''
        substitute \
          ${pkgs.protonup-qt}/share/applications/protonup-qt.desktop \
          $out \
          --replace-fail 'Exec=protonup-qt' 'Exec=${lib.getExe pkgs.protonup-qt}'
      '';

    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "pcmanfm.desktop";
        "x-directory/normal" = "pcmanfm.desktop";
        "x-scheme-handler/steam" = "steam.desktop";
        "x-scheme-handler/steamlink" = "steam.desktop";
      };
    };
  };
}
