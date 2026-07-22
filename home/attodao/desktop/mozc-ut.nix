{ inputs, pkgs, ... }:
let
  mergeUtDictionaries = pkgs.merge-ut-dictionaries.overrideAttrs (_old: {
    version = "0-unstable-${inputs.merge-ut-dictionaries.lastModifiedDate}";
    src = inputs.merge-ut-dictionaries;
    nativeBuildInputs = _old.nativeBuildInputs ++ [
      pkgs.bzip2
      pkgs.gzip
    ];
    preConfigure = ''
      cd src/merge

      substituteInPlace make.sh \
        --replace-fail '#!/bin/bash' '#!/bin/bash
set -e' \
        --replace-fail 'rm -rf mozcdic-ut*' 'rm -f mozcdic-ut.txt mozcdic-ut-*.txt' \
        --replace-fail '#alt_cannadic="true"' 'alt_cannadic="true"' \
        --replace-fail '#edict2="true"' 'edict2="true"' \
        --replace-fail '#neologd="true"' 'neologd="true"' \
        --replace-fail '#skk_jisyo="true"' 'skk_jisyo="true"' \
        --replace-fail 'git clone --depth 1 https://github.com/utuhiro78/mozcdic-ut-alt-cannadic.git' 'true # provided by Nix' \
        --replace-fail 'git clone --depth 1 https://github.com/utuhiro78/mozcdic-ut-edict2.git' 'true # provided by Nix' \
        --replace-fail 'git clone --depth 1 https://github.com/utuhiro78/mozcdic-ut-jawiki.git' 'true # provided by Nix' \
        --replace-fail 'git clone --depth 1 https://github.com/utuhiro78/mozcdic-ut-neologd.git' 'true # provided by Nix' \
        --replace-fail 'git clone --depth 1 https://github.com/utuhiro78/mozcdic-ut-personal-names.git' 'true # provided by Nix' \
        --replace-fail 'git clone --depth 1 https://github.com/utuhiro78/mozcdic-ut-place-names.git' 'true # provided by Nix' \
        --replace-fail 'git clone --depth 1 https://github.com/utuhiro78/mozcdic-ut-skk-jisyo.git' 'true # provided by Nix' \
        --replace-fail 'git clone --depth 1 https://github.com/utuhiro78/mozcdic-ut-sudachidict.git' 'true # provided by Nix'

      substituteInPlace merge_dictionaries.py \
        --replace-fail "url = 'https://api.github.com/repos/google/mozc/commits/master'" "url = 'file://$PWD/mozc-master.json'" \
        --replace-fail "'https://dumps.wikimedia.org/jawiki/latest/'" "'file://$PWD/'" \
        --replace-fail "'jawiki-latest-pages-articles-multistream-index.txt.bz2-rss.xml'" "'jawiki-index.rss.xml'"

      cp -r ${inputs."mozcdic-ut-alt-cannadic"} mozcdic-ut-alt-cannadic
      cp -r ${inputs."mozcdic-ut-edict2"} mozcdic-ut-edict2
      cp -r ${inputs."mozcdic-ut-jawiki"} mozcdic-ut-jawiki
      cp -r ${inputs."mozcdic-ut-neologd"} mozcdic-ut-neologd
      cp -r ${inputs."mozcdic-ut-personal-names"} mozcdic-ut-personal-names
      cp -r ${inputs."mozcdic-ut-place-names"} mozcdic-ut-place-names
      cp -r ${inputs."mozcdic-ut-skk-jisyo"} mozcdic-ut-skk-jisyo
      cp -r ${inputs."mozcdic-ut-sudachidict"} mozcdic-ut-sudachidict
      chmod -R u+w mozcdic-ut-*

      cp -r ${pkgs.mozc.src} mozc-master
      chmod -R u+w mozc-master
      ${pkgs.python3}/bin/python -m zipfile -c mozc-20260608.zip mozc-master
      printf '%s\n' '{"commit":{"committer":{"date":"2026-06-08T00:00:00+00:00"}}}' > mozc-master.json

      gzip -dc ${pkgs.jawiki-all-titles-in-ns0}/jawiki-all-titles-in-ns0.gz \
        | awk '{ print "0:0:" $0 }' \
        | bzip2 > jawiki-index.txt.bz2
      printf '%s\n' "<rss><channel><item><description><![CDATA[<a href=\"file://$PWD/jawiki-index.txt.bz2\">jawiki index</a>]]></description></item></channel></rss>" > jawiki-index.rss.xml
    '';
  });

  mozcUt = pkgs.mozc.override {
    merge-ut-dictionaries = mergeUtDictionaries;
    dictionaries = [ pkgs.mozcdic-ut-jawiki ];
  };

  fcitx5MozcUt = pkgs.fcitx5-mozc.override {
    mozc = mozcUt;
  };
in
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-skk
        fcitx5MozcUt
        qt6Packages.fcitx5-configtool
      ];

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
        "Groups/0/Items/1" = {
          "Name" = "keyboard-us";
          "Layout" = "us";
        };
      };
    };
  };

  # Home Manager generates an XDG autostart entry for fcitx5; disable it so the
  # systemd user service is the only launcher.
  xdg.configFile."autostart/org.fcitx.Fcitx5.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
