{
  config,
  lib,
  pkgs,
  ...
}:
let
  sshConfig = pkgs.writeText "attodao-ssh-config" ''
    Host *
      ForwardAgent no
      AddKeysToAgent no
      Compression no
      StrictHostKeyChecking accept-new
      Port 22
      HashKnownHosts no
      UserKnownHostsFile ~/.ssh/known_hosts
      ControlMaster auto
      ControlPersist 10m
      ControlPath ~/.ssh/cm-%C
      ServerAliveInterval 30
      ServerAliveCountMax 3

    Host attobox
      User attodao
      Port 22
      HostName attobox.attodao.cc

    Host attofort
      User attodao
      Port 22
      HostName attofort.attodao.cc

    Host devcon
      User dev
      Port 22
      HostName dev.attodao.cc

    Host desktop
      User attodao
      Port 22
      HostName desk.attodao.cc

    Host git.attodao.cc
      Port 22
      HostName git.attodao.cc
      User git
      IdentityFile ~/.ssh/id_ed25519
      IdentitiesOnly yes
  '';

  sshDir = "${config.home.homeDirectory}/.ssh";
  sshConfigPath = "${sshDir}/config";
  sshWrapper = pkgs.writeShellScriptBin "ssh" ''
    set -eu
    exec ${pkgs.openssh}/bin/ssh -F "$HOME/.ssh/config" "$@"
  '';
in
{
  home.packages = [ sshWrapper ];

  # OpenSSH rejects Home Manager's store symlink because the target is not user-owned.
  home.activation.installSshConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.coreutils}/bin/install -d -m 700 "${sshDir}"
    ${pkgs.coreutils}/bin/install -m 600 ${sshConfig} "${sshConfigPath}"
  '';
}
