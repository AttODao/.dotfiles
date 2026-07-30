{
  description = "attodesk flake inputs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-community-palettes = {
      url = "github:noctalia-dev/community-palettes";
      flake = false;
    };

    merge-ut-dictionaries = {
      url = "github:utuhiro78/merge-ut-dictionaries";
      flake = false;
    };

    mozcdic-ut-alt-cannadic = {
      url = "github:utuhiro78/mozcdic-ut-alt-cannadic";
      flake = false;
    };

    mozcdic-ut-edict2 = {
      url = "github:utuhiro78/mozcdic-ut-edict2";
      flake = false;
    };

    mozcdic-ut-jawiki = {
      url = "github:utuhiro78/mozcdic-ut-jawiki";
      flake = false;
    };

    mozcdic-ut-neologd = {
      url = "github:utuhiro78/mozcdic-ut-neologd";
      flake = false;
    };

    mozcdic-ut-personal-names = {
      url = "github:utuhiro78/mozcdic-ut-personal-names";
      flake = false;
    };

    mozcdic-ut-place-names = {
      url = "github:utuhiro78/mozcdic-ut-place-names";
      flake = false;
    };

    mozcdic-ut-skk-jisyo = {
      url = "github:utuhiro78/mozcdic-ut-skk-jisyo";
      flake = false;
    };

    mozcdic-ut-sudachidict = {
      url = "github:utuhiro78/mozcdic-ut-sudachidict";
      flake = false;
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    inputs = builtins.removeAttrs inputs [ "self" ];
  };
}
