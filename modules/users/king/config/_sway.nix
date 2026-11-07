{ ... }: {
  wayland.windowManager.sway.config = {
    gaps = {
        inner = 0;
        outer = 0;
    };
    
    input."*".xkb_layout = "us";
    menu = "rofi -show drun";
  };
}
