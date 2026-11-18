{ inputs, ... }: {
  flake.modules.nixos.stylix = { lib, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      image = lib.mkDefault ../../wallpapers/mountains_lake.jpg;
      polarity = lib.mkDefault "light";

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
