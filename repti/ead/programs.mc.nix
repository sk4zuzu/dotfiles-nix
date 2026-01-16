{ ... }: {
  programs.mc = {
    enable = true;

    settings.Layout = {
      command_prompt = "true";
      free_space = "false";
      keybar_visible = "false";
      menubar_visible = "false";
      message_visible = "false";
      xterm_title = "false";
    };

    settings.Midnight-Commander = {
      skin = "modarin256";
      use_internal_edit = "false";
    };

    settings.Panels = {
      navigate_with_arrows = "true";
    };
  };
}
