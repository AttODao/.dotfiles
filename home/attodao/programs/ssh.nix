{ pkgs, ... }:
let
  cloudflared = "${pkgs.cloudflared}/bin/cloudflared";

  cloudflareTunnelSsh = {
    proxyCommand = "${cloudflared} access ssh --hostname %h";
  };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };

      attobox = cloudflareTunnelSsh // {
        HostName = "attobox.attodao.cc";
        User = "attodao";
      };

      attofort = cloudflareTunnelSsh // {
        HostName = "attofort.attodao.cc";
        User = "attodao";
      };

      "git.attodao.cc" = cloudflareTunnelSsh // {
        HostName = "git.attodao.cc";
        IdentityFile = [ "~/.ssh/id_ed25519_forgejo" ];
        IdentitiesOnly = true;
      };
    };
  };
}
