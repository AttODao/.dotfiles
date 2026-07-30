{
  inputs,
  hostName,
  lib,
  pkgs,
  ...
}:
let
  cursor = import ../desktop-theme/cursor.nix { inherit pkgs; };
in
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  programs.noctalia-greeter = {
    enable = true;

    settings = {
      user.default = "attodao";
      session.default = "Hyprland (uwsm-managed)";

      cursor = {
        theme = cursor.cursorTheme;
        size = cursor.cursorSize;
        path = "${cursor.cursorPackage}/share/icons";
      };
    }
    // lib.optionalAttrs (hostName == "attodesk") {
      output.name = "DP-1";
    };
  };
}
