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
    deps.url = "path:./flake-inputs";
  };

  outputs =
    { deps, ... }:
    let
      inherit (deps) inputs;
      lib = inputs.nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      hostNames = [
        "attodesk"
        "attolap"
      ];
      resolvedFeatures = import ./lib/features.nix {
        featureRoot = ./modules/features;
        inherit hostNames lib;
      };
      mkHome =
        hostName:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs hostName;
          };
          modules = [
            ./home/attodao
          ]
          ++ resolvedFeatures.homeModulesFor hostName;
        };
      mkHost =
        hostName:
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostName;
          };

          modules = [
            ./hosts/${hostName}
            ./modules/nixos

            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs hostName;
                };
                users.attodao.imports = [
                  ./home/attodao
                ]
                ++ resolvedFeatures.homeModulesFor hostName;
              };
            }
          ]
          ++ resolvedFeatures.nixosModulesFor hostName;
        };
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (hostName: {
          name = hostName;
          value = mkHost hostName;
        }) hostNames
      );

      homeConfigurations = {
        attodao = mkHome "attodesk";
        attodao-attodesk = mkHome "attodesk";
        attodao-attolap = mkHome "attolap";
      };

      featureMatrix = resolvedFeatures.matrix;

      checks.${system} = {
        nixos-attodesk = (mkHost "attodesk").config.system.build.toplevel;
        nixos-attolap = (mkHost "attolap").config.system.build.toplevel;
        home-attodesk = (mkHome "attodesk").activationPackage;
        home-attolap = (mkHome "attolap").activationPackage;
        feature-matrix = pkgs.writeText "feature-matrix.json" (builtins.toJSON resolvedFeatures.matrix);
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
