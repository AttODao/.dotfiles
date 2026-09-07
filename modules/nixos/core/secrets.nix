{
  hostName,
  lib,
  ...
}:

let
  secretsRoot = ../../../secrets;
  loginPinFile = secretsRoot + "/login-pin/${hostName}/attodao.pbkdf2";
  noctaliaCalendarPasswordFile = secretsRoot + "/noctalia/calendar-password";
  mkBinarySecret =
    {
      sopsFile,
      owner,
      group,
    }:
    {
      inherit
        group
        owner
        sopsFile
        ;
      format = "binary";
      key = "";
      mode = "0400";
    };
in
{
  sops = {
    age = {
      keyFile = "/var/lib/sops-nix/key-${hostName}.txt";
      generateKey = false;
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
    secrets =
      lib.optionalAttrs (builtins.pathExists loginPinFile) {
        "login-pin/attodao.pbkdf2" = mkBinarySecret {
          sopsFile = loginPinFile;
          owner = "root";
          group = "root";
        };
      }
      // lib.optionalAttrs (builtins.pathExists noctaliaCalendarPasswordFile) {
        "noctalia/calendar-password" = mkBinarySecret {
          sopsFile = noctaliaCalendarPasswordFile;
          owner = "attodao";
          group = "users";
        };
      };
  };
}
