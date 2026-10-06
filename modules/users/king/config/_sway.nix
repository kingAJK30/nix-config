{ ... }: {
  wayland.windowManager.sway.config = {
    gaps.inner = 5;
    input."*".xkb_layout = "us";
  };
}
