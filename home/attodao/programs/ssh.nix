{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        StrictHostKeyChecking = "accept-new";
        Port = 22;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "auto";
        ControlPersist = "10m";
        ControlPath = "~/.ssh/cm-%C";
        ServerAliveInterval = 30;
        ServerAliveCountMax = 3;
      };

      attobox = {
        User = "attodao";
        Port = 22;
        HostName = "attobox";
      };

      attofort = {
        User = "attodao";
        Port = 22;
        HostName = "attofort";
      };

      devcon = {
        User = "dev";
        Port = 22;
        HostName = "devcon";
      };

      desktop = {
        User = "attodao";
        Port = 22;
        HostName = "desktop";
      };

      "git.attodao.cc" = {
        Port = 22;
        HostName = "git.attodao.cc";
        User = "git";
        IdentityFile = [ "~/.ssh/id_ed25519_forgejo" ];
        IdentitiesOnly = true;
      };
    };
  };
}
