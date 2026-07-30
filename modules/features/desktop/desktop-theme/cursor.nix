{ pkgs }:
let
  cursorTheme = "Yanfei-Cursors";
  cursorSize = 48;
  # The source only contains Xcursor assets, so build a matching Hyprcursor theme in the derivation.
  cursorPackage = pkgs.stdenvNoCC.mkDerivation {
    pname = "yanfei-cursors";
    version = "1.0";
    src = pkgs.fetchurl {
      name = "yanfei-cursors.zip";
      url = "https://cloud.attodao.cc/remote.php/dav/public-files/cqsQAfeTRsTMbmU/yanfei-cursors.zip";
      hash = "sha256-l48eiQ3qqzhL6LMSneJ42PpKsWq2LaJHa5AR0g46bG0=";
    };
    sourceRoot = ".";
    nativeBuildInputs = [
      pkgs.hyprcursor
      pkgs.unzip
      pkgs.xcur2png
    ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/icons/${cursorTheme}
      cp -r cursors index.theme $out/share/icons/${cursorTheme}/

      work="$TMPDIR/yanfei-cursors-build"
      mkdir -p "$work/yanfei-cursors"
      cp -r cursors index.theme "$work/yanfei-cursors/"
      chmod -R u+w "$work/yanfei-cursors"

      hyprcursor-util --extract "$work/yanfei-cursors" >/dev/null
      substituteInPlace "$work/extracted_yanfei-cursors/manifest.hl" \
        --replace-fail "name = Extracted Theme" "name = ${cursorTheme}" \
        --replace-fail "description = Automatically extracted with hyprcursor-util" "description = 煙緋 マウスカーソル"
      (cd "$work" && hyprcursor-util --create extracted_yanfei-cursors >/dev/null)
      cp -r "$work/theme_${cursorTheme}/manifest.hl" "$work/theme_${cursorTheme}/hyprcursors" $out/share/icons/${cursorTheme}/

      runHook postInstall
    '';
  };
in
{
  inherit cursorPackage cursorSize cursorTheme;
}
