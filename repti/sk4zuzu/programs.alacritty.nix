{ ... }: {
  programs.alacritty = {
    enable = true;

    settings.env = {
      TERM = "xterm-256color";
      WINIT_HIDPI_FACTOR = "1.0";
    };

    settings.colors.primary = {
      background = "0x000000";
      foreground = "0x99e199";
    };

    settings.colors.cursor = {
      text = "0x000000";
      cursor = "0xff0000";
    };

    settings.font.bold = {
      family = "MonacoLigaturized";
      style = "Bold";
    };

    settings.font.italic = {
      family = "MonacoLigaturized";
      style = "Italic";
    };

    settings.font.normal = {
      family = "MonacoLigaturized";
      style = "Regular";
    };

    settings.font.size = 10;
  };
}
