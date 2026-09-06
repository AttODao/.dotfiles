{
  inputs,
  pkgs,
  ...
}:
let
  opencloud =
    inputs.opencloud-nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencloud-desktop;
in
{
  home.packages = [
    opencloud
  ];

  xdg = {
    # Mask both upstream autostart names so systemd remains the only launcher.
    configFile."autostart/OpenCloud.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=OpenCloud Desktop
      Hidden=true
    '';

    configFile."autostart/OpenCloud.desktop.backup" = {
      force = true;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=OpenCloud Desktop
        Hidden=true
      '';
    };

    dataFile."applications/opencloudcmd.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=OpenCloud Desktop
      Hidden=true
    '';
  };

  systemd.user.services.opencloud = {
    Unit = {
      Description = "OpenCloud desktop client";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${opencloud}/bin/opencloud";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
