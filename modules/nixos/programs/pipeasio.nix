{
  config,
  lib,
  pkgs,
  ...
}:
let
  pipeasio = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "pipeasio";
    version = "1.2.0";

    src = pkgs.fetchFromGitHub {
      owner = "M0n7y5";
      repo = "pipeasio";
      tag = "v${finalAttrs.version}";
      hash = "sha256-iq6xfRi0qc8tBPRP/vfpCBbysIba12ABGTqsEfhkyUE=";
    };

    nativeBuildInputs = [
      pkgs.cmake
      pkgs.makeWrapper
      pkgs.ninja
      pkgs.pkg-config
      pkgs.qt6.wrapQtAppsHook
      pkgs.wineWow64Packages.stable
    ];

    buildInputs = [
      pkgs.qt6.qtbase
      pkgs.pipewire
    ];

    dontWrapQtApps = true;

    cmakeFlags = [
      "-DBUILD_SETTINGS_PANEL=ON"
      "-DBUILD_TESTS=OFF"
      "-DWINE_INCLUDE_DIRS=${lib.concatStringsSep ";" [
        "${pkgs.wineWow64Packages.stable}/include/wine"
        "${pkgs.wineWow64Packages.stable}/include/wine/windows"
      ]}"
    ];

    postPatch = ''
      patchShebangs pipeasio-register
    '';

    postFixup = ''
      wrapQtApp $out/bin/pipeasio-settings

      wrapProgram $out/bin/pipeasio-register \
        --prefix PATH : ${lib.makeBinPath [
          pkgs.coreutils
          pkgs.findutils
          pkgs.wineWow64Packages.stable
        ]} \
        --set PIPEASIO_PREFIX $out
    '';

    meta = {
      homepage = "https://github.com/M0n7y5/pipeasio";
      description = "ASIO to PipeWire driver for Wine and Proton";
      license = lib.licenses.gpl3Plus;
      platforms = [ "x86_64-linux" ];
      mainProgram = "pipeasio-register";
    };
  });
in
lib.mkMerge [
  {
    environment.systemPackages = [ pipeasio ];
  }
  (lib.mkIf config.programs.steam.enable {
    programs.steam.package = pkgs.steam.override {
      extraEnv = {
        # Steam/Proton needs the PipeASIO unixlib directory on WINEDLLPATH.
        WINEDLLPATH = "${pipeasio}/lib/wine";
      };
    };
  })
]
