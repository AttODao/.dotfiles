{
  programs.zed-editor = {
    enable = true;
    userSettings = {
      autosave = "on_focus_change";
      agent_servers."pi-acp".type = "registry";
    };
  };
}
