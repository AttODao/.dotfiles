{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.username = "attodao";
  home.homeDirectory = "/home/${config.home.username}";

  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default
  ];

  # ==============================
  # ユーザー向けパッケージ
  # ==============================
  home.packages = with pkgs; [
    foot
    floorp-bin
    zed-editor
    nixd
    nil
  ];

  # ==============================
  # Niri
  # ==============================
  programs.niri = {
    settings = {
      spawn-at-startup = [
        {
          command = [
            "qs"
            "-c"
            "noctalia-shell"
          ];
        }
        {
          command = [
            "fcitx5 -r"
          ];
        }
      ];
    };
  };

  # ==============================
  # Noctalia
  # ==============================
  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      calendarSupport = true;
    };
  };

  # ==============================
  # 日本語入力（fcitx5 + Mozc）
  # ==============================
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc # Google日本語入力ベースのIME
      fcitx5-gtk # GTKアプリ対応
      qt6Packages.fcitx5-configtool # GUI設定ツール
    ];
  };

  # ==============================
  # 日本語入力の環境変数（Wayland 必須）
  # ==============================
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus"; # Wayland ネイティブアプリ向け
  };

  # ※ インストール時の値から変更しないこと
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
