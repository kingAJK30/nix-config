{ ... }: {
  programs.foot.settings = {
    main = {
      font = "JetBrains Mono:size=12";
      dpi-aware = "yes";
      pad = "12x12";
    };
    scrollback.multiplier = 3.0;
  };
}
