{ ... }: {
  programs.foot.settings = {
    main = {
      font = "JetBrainsMono Nerd Font Mono:size=12";
      dpi-aware = "yes";
      pad = "12x12";
    };
    scrollback.multiplier = 3.0;
  };
}
