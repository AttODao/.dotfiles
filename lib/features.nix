{
  featureRoot,
  hostNames,
  lib,
}:
let
  discoverFeaturePaths =
    directory:
    let
      entries = builtins.readDir directory;
    in
    lib.concatMap (
      name:
      let
        path = directory + "/${name}";
      in
      if entries.${name} != "directory" then
        [ ]
      else if builtins.pathExists (path + "/default.nix") then
        [ path ]
      else
        discoverFeaturePaths path
    ) (builtins.attrNames entries);
  featurePaths = discoverFeaturePaths featureRoot;
  featurePathNames = map (path: builtins.baseNameOf (toString path)) featurePaths;
  duplicateFeatureNames = lib.filter (
    name: builtins.length (lib.filter (candidate: candidate == name) featurePathNames) > 1
  ) (lib.unique featurePathNames);
  featureNames = lib.sort builtins.lessThan featurePathNames;
  featurePathsByName = lib.listToAttrs (
    map (path: {
      name = builtins.baseNameOf (toString path);
      value = path;
    }) featurePaths
  );
  allowedFields = [
    "homeModules"
    "homePackages"
    "hosts"
    "nixosModules"
    "requires"
    "systemPackages"
  ];

  # Stop at feature directories so category folders and feature assets need no registry entries.
  definitions = lib.genAttrs featureNames (
    name: import (featurePathsByName.${name} + "/default.nix")
  );
  unknownFields = lib.concatMap (
    name:
    map (field: "${name}.${field}") (
      lib.filter (field: !(builtins.elem field allowedFields)) (builtins.attrNames definitions.${name})
    )
  ) featureNames;

  features = lib.genAttrs featureNames (
    name:
    let
      definition = definitions.${name};
    in
    {
      hosts = definition.hosts or (throw "feature '${name}' must declare hosts");
      requires = definition.requires or [ ];
      nixosModules = definition.nixosModules or [ ];
      homeModules = definition.homeModules or [ ];
      systemPackages = definition.systemPackages or null;
      homePackages = definition.homePackages or null;
    }
  );

  emptyFeatures = lib.filter (
    name:
    let
      feature = features.${name};
    in
    feature.nixosModules == [ ]
    && feature.homeModules == [ ]
    && feature.systemPackages == null
    && feature.homePackages == null
  ) featureNames;
  repeatedHosts = lib.filter (
    name: builtins.length features.${name}.hosts != builtins.length (lib.unique features.${name}.hosts)
  ) featureNames;
  selfDependencies = lib.filter (name: builtins.elem name features.${name}.requires) featureNames;

  unknownHosts = lib.unique (
    lib.concatMap (
      name: lib.filter (hostName: !(builtins.elem hostName hostNames)) features.${name}.hosts
    ) featureNames
  );

  unknownDependencies = lib.concatMap (
    name:
    map (dependency: "${name} -> ${dependency}") (
      lib.filter (dependency: !(builtins.hasAttr dependency features)) features.${name}.requires
    )
  ) featureNames;

  missingHostDependencies = lib.concatMap (
    name:
    lib.concatMap (
      hostName:
      map (dependency: "${name}@${hostName} -> ${dependency}") (
        lib.filter (
          dependency:
          builtins.hasAttr dependency features && !(builtins.elem hostName features.${dependency}.hosts)
        ) features.${name}.requires
      )
    ) features.${name}.hosts
  ) featureNames;

  validated =
    assert lib.assertMsg (duplicateFeatureNames == [ ])
      "feature names are duplicated across categories: ${lib.concatStringsSep ", " duplicateFeatureNames}";
    assert lib.assertMsg (
      unknownFields == [ ]
    ) "features declare unsupported fields: ${lib.concatStringsSep ", " unknownFields}";
    assert lib.assertMsg (
      emptyFeatures == [ ]
    ) "features contain no modules or packages: ${lib.concatStringsSep ", " emptyFeatures}";
    assert lib.assertMsg (
      repeatedHosts == [ ]
    ) "features repeat host names: ${lib.concatStringsSep ", " repeatedHosts}";
    assert lib.assertMsg (
      selfDependencies == [ ]
    ) "features depend on themselves: ${lib.concatStringsSep ", " selfDependencies}";
    assert lib.assertMsg (
      unknownHosts == [ ]
    ) "features reference unknown hosts: ${lib.concatStringsSep ", " unknownHosts}";
    assert lib.assertMsg (
      unknownDependencies == [ ]
    ) "features have unknown dependencies: ${lib.concatStringsSep ", " unknownDependencies}";
    assert lib.assertMsg (missingHostDependencies == [ ])
      "feature dependencies are not enabled on the same host: ${lib.concatStringsSep ", " missingHostDependencies}";
    true;

  namesForHost =
    hostName:
    assert validated;
    assert lib.assertMsg (builtins.elem hostName hostNames)
      "cannot resolve features for unknown host '${hostName}'";
    lib.filter (name: builtins.elem hostName features.${name}.hosts) featureNames;

  packageModule =
    optionPath: packages:
    { pkgs, ... }:
    lib.setAttrByPath optionPath (packages pkgs);

  nixosModulesFor =
    hostName:
    lib.concatMap (
      name:
      let
        feature = features.${name};
      in
      feature.nixosModules
      ++ lib.optional (feature.systemPackages != null) (
        packageModule [ "environment" "systemPackages" ] feature.systemPackages
      )
    ) (namesForHost hostName);

  homeModulesFor =
    hostName:
    lib.concatMap (
      name:
      let
        feature = features.${name};
      in
      feature.homeModules
      ++ lib.optional (feature.homePackages != null) (
        packageModule [ "home" "packages" ] feature.homePackages
      )
    ) (namesForHost hostName);
in
{
  inherit
    featureNames
    features
    homeModulesFor
    namesForHost
    nixosModulesFor
    ;

  matrix = lib.genAttrs hostNames namesForHost;
}
