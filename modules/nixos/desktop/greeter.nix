{
  config,
  lib,
  pkgs,
  ...
}:

let
  greeterNiriConfig = pkgs.writeText "niri-greeter.kdl" ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }

        touchpad {
            tap
            natural-scroll
        }
    }

    output "DP-1" {
        mode "2560x1440@60"
        scale 1
        position x=0 y=0
    }

    output "HDMI-A-1" {
        off
    }

    output "HDMI-A-2" {
        off
    }

    spawn-at-startup "${pkgs.runtimeShell}" "-c" "${config.programs.regreet.package}/bin/regreet; ${pkgs.niri}/bin/niri msg action quit --skip-confirmation"

    binds {
        Mod+Shift+E { quit; }
    }
  '';
in
{
  programs.regreet = {
    enable = true;

    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
      size = 16;
    };

    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };

    settings = {
      GTK.application_prefer_dark_theme = true;

      appearance.greeting_msg = "Welcome back, attodao";

      widget.clock = {
        format = "%Y-%m-%d  %H:%M";
        resolution = "1s";
      };

      commands = {
        reboot = [
          "systemctl"
          "reboot"
        ];
        poweroff = [
          "systemctl"
          "poweroff"
        ];
      };
    };

    extraCss = ''
      window {
        background: linear-gradient(135deg, #11111b, #1e1e2e 45%, #313244);
      }

      box#body {
        background-color: rgba(17, 17, 27, 0.78);
        border-radius: 24px;
        padding: 32px;
      }

      entry {
        border-radius: 14px;
        padding: 10px 14px;
      }

      button {
        border-radius: 14px;
        padding: 8px 16px;
      }
    '';
  };

  services.greetd.settings.default_session.command =
    lib.mkForce "${pkgs.dbus}/bin/dbus-run-session ${pkgs.niri}/bin/niri --config ${greeterNiriConfig}";
}
