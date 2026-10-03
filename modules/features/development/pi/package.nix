{
  lib,
  pi-coding-agent,
  fetchFromGitHub,
  fetchurl,
  fetchNpmDeps,
}:
# Remove this override once the pinned nixpkgs provides Pi >= 1.0.0.
pi-coding-agent.overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "earendil-works";
      repo = "pi";
      tag = "v${finalAttrs.version}";
      hash = "sha256-CGznIVHXG6gr2F8vzHcR/v4P9xJgZHeMTt/CJ/kB78o=";
    };

    npmDepsHash = "sha256-ndEvWdB6sa5nNNtabk2OMZKUFG9x3op185deZHxFnXk=";
    npmDeps = fetchNpmDeps {
      name = "pi-coding-agent-${finalAttrs.version}-npm-deps";
      inherit (finalAttrs) src;
      hash = finalAttrs.npmDepsHash;
    };

    modelData = fetchurl {
      url = "https://registry.npmjs.org/@earendil-works/pi-ai/-/pi-ai-${finalAttrs.version}.tgz";
      hash = "sha256-85uZwpuFmPF1sQhA5dKoGYPnwM5crk19+DoQB0R9LCs=";
    };

    buildPhase = ''
      runHook preBuild
      npm run build:offline
      runHook postBuild
    '';

    postInstall =
      lib.replaceStrings
        [ "@earendil-works/pi-client:packages/client" ]
        [
          ''
            @earendil-works/pi-client:packages/client \
                          @earendil-works/pi-codemode:packages/codemode \
                          @earendil-works/pi-mcp:packages/mcp''
        ]
        previousAttrs.postInstall;

    meta = previousAttrs.meta // {
      changelog = "https://github.com/earendil-works/pi/blob/v${finalAttrs.version}/packages/coding-agent/CHANGELOG.md";
    };
  }
)
