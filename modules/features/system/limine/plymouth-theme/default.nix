{ imagemagick, runCommand }:

runCommand "attodesk-plymouth-theme" { } ''
  themeDir="$out/share/plymouth/themes/attodesk"
  mkdir -p "$themeDir"

  substitute ${./attodesk.plymouth} "$themeDir/attodesk.plymouth" \
    --replace-fail "@THEME_DIR@" "$themeDir"
  cp ${./attodesk.script} "$themeDir/attodesk.script"
  ${imagemagick}/bin/magick \
    ${../assets/attodesk-black.png} \
    -resize '960x360>' \
    "$themeDir/attodesk.png"
''
