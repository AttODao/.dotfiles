{
  description = "attodesk NixOS Configuration";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
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

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.attodesk = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/attodesk

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.attodao = import ./home/attodao;
          }
        ];
      };

      homeConfigurations.attodao = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home/attodao
        ];
      };
    };
}
