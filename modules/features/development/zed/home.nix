{
  home.file.".local/share/zed/external_agents/registry/npx/codex-acp/.npmrc".text = ''
    audit=false
    fetch-retries=1
    fetch-retry-maxtimeout=5000
    fetch-retry-mintimeout=1000
    fetch-timeout=10000
    prefer-offline=true
  '';

  programs.zed-editor = {
    enable = true;
    userSettings = {
      autosave = "on_focus_change";
      agent_servers."codex-acp".default_config_options.reasoning_effort = "xhigh";
    };
  };
}
