{
  cmake,
  coreutils,
  fetchFromGitHub,
  findutils,
  lib,
  makeWrapper,
  ninja,
  pipewire,
  pkg-config,
  qt6,
  stdenv,
  wineWow64Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pipeasio";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "M0n7y5";
    repo = "pipeasio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iq6xfRi0qc8tBPRP/vfpCBbysIba12ABGTqsEfhkyUE=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    wineWow64Packages.stable
  ];

  buildInputs = [
    qt6.qtbase
    pipewire
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DBUILD_SETTINGS_PANEL=ON"
    "-DBUILD_TESTS=OFF"
    "-DWINE_INCLUDE_DIRS=${
      lib.concatStringsSep ";" [
        "${wineWow64Packages.stable}/include/wine"
        "${wineWow64Packages.stable}/include/wine/windows"
      ]
    }"
  ];

  postPatch = ''
    patchShebangs pipeasio-register
  '';

  postFixup = ''
    wrapQtApp $out/bin/pipeasio-settings

    wrapProgram $out/bin/pipeasio-register \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          findutils
          wineWow64Packages.stable
        ]
      } \
      --set PIPEASIO_PREFIX $out
  '';

  meta = {
    homepage = "https://github.com/M0n7y5/pipeasio";
    description = "ASIO to PipeWire driver for Wine and Proton";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "pipeasio-register";
  };
})
