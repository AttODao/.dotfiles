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
      Port 22
      HostName attobox.attodao.cc
      User attodao
      IdentityFile ~/.ssh/id_ed25519

    Host attofort
      Port 22
      HostName attofort.attodao.cc
      User attodao
      IdentityFile ~/.ssh/id_ed25519

    Host devcon
      Port 22
      HostName dev.attodao.cc
      User dev
      IdentityFile ~/.ssh/id_ed25519

    Host desktop
      Port 22
      HostName desk.attodao.cc
      User attodao
      IdentityFile ~/.ssh/id_ed25519

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
