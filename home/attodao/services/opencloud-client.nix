{
  hostName,
  lib,
  pkgs,
  ...
}:
let
  qmlImportPath = lib.makeSearchPath "lib/qt-6/qml" [
    pkgs.qt6.qtdeclarative
    pkgs.opencloud-desktop
  ];
in
lib.mkIf (hostName == "attodesk")
{
  home.packages = [
    pkgs.opencloud-desktop
  ];

  # Use the systemd service as the single startup path for OpenCloud.
  xdg.configFile."autostart/OpenCloud.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=OpenCloud Desktop
    Hidden=true
  '';

  systemd.user.services.opencloud = {
    Unit = {
      Description = "OpenCloud desktop client";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.opencloud-desktop}/bin/opencloud";
      Environment = [
        "NIXPKGS_QT6_QML_IMPORT_PATH=${qmlImportPath}"
        "QML2_IMPORT_PATH=${qmlImportPath}"
      ];
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
