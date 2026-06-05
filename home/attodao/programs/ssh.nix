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

    matchBlocks = {
      attobox = cloudflareTunnelSsh // {
        hostname = "attobox.attodao.cc";
        user = "attodao";
      };

      attofort = cloudflareTunnelSsh // {
        hostname = "attofort.attodao.cc";
        user = "attodao";
      };

      "git.attodao.cc" = cloudflareTunnelSsh // {
        hostname = "git.attodao.cc";
        identityFile = [ "~/.ssh/id_ed25519_forgejo" ];
        identitiesOnly = true;
      };
    };
  };
}
