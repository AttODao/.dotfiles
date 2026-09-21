{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-skk
        qt6Packages.fcitx5-configtool
      ];

      settings.globalOptions."Hotkey/AltTriggerKeys"."0" = "";

      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          "Name" = "Default";
          "Default Layout" = "us";
          "DefaultIM" = "skk";
        };
        "Groups/0/Items/0" = {
          "Name" = "skk";
          "Layout" = "us";
        };
      };
    };
  };

  # Mask Home Manager's autostart entry so systemd remains the only launcher.
  xdg.configFile."autostart/org.fcitx.Fcitx5.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
