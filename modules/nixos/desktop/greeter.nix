{ pkgs, ... }:

{
  programs.regreet = {
    enable = true;

    cageArgs = [
      "-s"
      "-d"
      "-m"
      "last"
    ];

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
      GTK = {
        application_prefer_dark_theme = true;
      };

      appearance = {
        greeting_msg = "Welcome back, attodao";
      };

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
        box-shadow: 0 12px 48px rgba(0, 0, 0, 0.45);
      }

      label {
        font-weight: 600;
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
}
