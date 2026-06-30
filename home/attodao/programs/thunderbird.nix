{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-esr;
    languagePacks = [ "ja" ];

    profiles.attodao = {
      isDefault = true;
      accountsOrder = [
        "attodao"
        "gmail"
      ];
      settings = {
        "mail.spellcheck.inline" = true;
        "mailnews.start_page.enabled" = false;
      };
    };
  };

  accounts = {
    calendar.basePath = ".local/share/calendars";

    email.accounts = {
      attodao = {
        primary = true;
        address = "attodao@attodao.cc";
        realName = "AttODao";
        userName = "attodao@attodao.cc";

        imap = {
          host = "mail.attodao.cc";
          port = 993;
          authentication = "plain";
          tls.enable = true;
        };

        smtp = {
          host = "mail.attodao.cc";
          port = 587;
          authentication = "plain";
          tls = {
            enable = true;
            useStartTls = true;
          };
        };

        thunderbird.enable = true;
      };

      gmail = {
        address = "atsuatat@gmail.com";
        realName = "AttODao";
        flavor = "gmail.com";
        thunderbird.enable = true;
      };
    };
  };
}
