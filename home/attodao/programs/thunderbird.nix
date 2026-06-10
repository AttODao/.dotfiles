{
  programs.thunderbird = {
    enable = true;
    languagePacks = [ "ja" ];

    profiles.attodao = {
      isDefault = true;
      accountsOrder = [
        "attodao"
        "gmail"
      ];
      calendarAccountsOrder = [ "sogo" ];
      settings = {
        "mail.spellcheck.inline" = true;
        "mailnews.start_page.enabled" = false;
      };
    };
  };

  accounts = {
    email.accounts = {
      attodao = {
        primary = true;
        address = "attodao@attodao.cc";
        realName = "AttO";
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
        realName = "AttO";
        flavor = "gmail.com";
        thunderbird.enable = true;
      };
    };

    calendar.accounts.sogo = {
      primary = true;
      remote = {
        type = "caldav";
        url = "https://mail.attodao.cc/SOGo/dav/attodao@attodao.cc/Calendar/personal/";
        userName = "attodao@attodao.cc";
      };
      thunderbird = {
        enable = true;
        color = "#3584e4";
        settings =
          id:
          {
            "calendar.registry.calendar_${id}.imip.identity.key" =
              "id_${builtins.hashString "sha256" "attodao"}";
            "calendar.registry.calendar_${id}.refreshInterval" = 15;
          };
      };
    };
  };
}
