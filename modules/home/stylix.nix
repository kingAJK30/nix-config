{ pkgs, ... }:

{
  stylix.enable = true;
  stylix.autoEnable = true;

  stylix.image = ../../wallpapers/default.jpg;
  
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-mirage.yaml"; # force hand crafted Base16 scheme from nixpkgs (https://tinted-theming.github.io/tinted-gallery/)

  stylix.polarity = "dark"; # dark theme

  stylix.targets.alacritty.enable = true;
  stylix.targets.waybar.enable = true;
  stylix.targets.rofi.enable = true;

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    serif = {
      package = pkgs.dejavu_fonts;
      name    = "DejaVu Serif";
    };
    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name    = "Noto Color Emoji";
    };
    sizes = {
      terminal    = 12;
      applications = 11;
    };
  };

}
