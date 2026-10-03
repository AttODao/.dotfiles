{
  config,
  pkgs,
  ...
}:
let
  agentDir = config.programs.pi-coding-agent.configDir;

  piSessionsSource = pkgs.fetchFromGitHub {
    owner = "thurstonsand";
    repo = "pi-sessions";
    rev = "68a634990477b60fbec63504d95ad1932917469a";
    hash = "sha256-kJ3vK4BQP176Ut/0FojGlCImNgkiDMJfhcB/3sZmTLk=";
  };

  ponytailSource = pkgs.fetchFromGitHub {
    owner = "DietrichGebert";
    repo = "ponytail";
    rev = "v4.10.3";
    hash = "sha256-aypYnQf+zkKGj+dfs+qFKTFIvaick9p0XJNtPkSwIB0=";
  };
in
{
  programs.pi-coding-agent = {
    enable = true;
    package = pkgs.callPackage ./package.nix { };

    settings = {
      defaultTools = [
        "read"
        "grep"
        "find"
        "ls"
        "bash"
        "edit"
        "write"
      ];
      sessions.autoTitle.refreshTurns = 4;
    };
  };

  # pi-sessions uses tmux for background subagents, including startup reconciliation.
  home.packages = [ pkgs.tmux ];

  # Pi discovers package manifests here.
  home.file."${agentDir}/extensions/pi-sessions".source = piSessionsSource;
  home.file."${agentDir}/extensions/ponytail".source = ponytailSource;

  # Ponytail's skills are exposed as /skill:ponytail-* commands.
  home.file."${agentDir}/skills/ponytail".source = "${ponytailSource}/skills";
}
