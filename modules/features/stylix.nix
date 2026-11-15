{ inputs, ... }: {
  flake.modules.nixos.stylix = { lib, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      image = lib.mkDefault ../../wallpapers/space_cabin.jpg;
      polarity = lib.mkDefault "dark";

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
        sizes.terminal = 12;
      };
    };
  };
}
