{
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  # フリーでないパッケージを許可
  nixpkgs.config.allowUnfree = true;

  # ==============================
  # ブートローダー
  # ==============================
  boot.loader = {
    systemd-boot.enable = false;
    limine = {
      enable = true;
      maxGenerations = 10; # 表示する NixOS の世代数
    };

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest; # 最新カーネル

  # ==============================
  # ネットワーク
  # ==============================
  networking.hostName = "attodesk";
  networking.networkmanager.enable = true;

  # ==============================
  # Bluetooth
  # ==============================
  hardware.bluetooth.enable = true;

  # ==============================
  # SSH
  # ==============================
  services.openssh.enable = true;

  # ==============================
  # タイムゾーン・日本語ロケール
  # ==============================
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.extraLocaleSettings.LC_ALL = "ja_JP.UTF-8";

  # ==============================
  # グラフィック
  # ==============================
  hardware.graphics.enable = true;

  # ==============================
  # ログイン画面（greetd）
  # ==============================
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      user = "greeter";
    };
  };

  # ==============================
  # Niri
  # ==============================
  programs.niri.enable = true;

  # ==============================
  # evolution-data-server (Calendar event support)
  # ==============================
  services.gnome.evolution-data-server.enable = true;

  # ==============================
  # サウンド（Pipewire）
  # ==============================
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # ==============================
  # フォント
  # ==============================
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      nerd-fonts.jetbrains-mono
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans CJK JP" ];
      serif = [ "Noto Serif CJK JP" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };

  # ==============================
  # 基本パッケージ
  # ==============================
  environment.systemPackages = with pkgs; [
  ];

  # ==============================
  # ユーザー
  # ==============================
  users.users."attodao" = {
    isNormalUser = true;
    description = "AttODao";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "audio"
    ];
  };

  # ※ インストール時の値から変更しないこと
  system.stateVersion = "26.05";
}
