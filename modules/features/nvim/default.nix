{ self, inputs, ... }: {
  flake.nixosModules.Neovim = { pkgs, lib, ... }: {
    programs.neovim = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.Neovim;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  perSystem = { pkgs, lib, ... }: let
    
    baseSettings = {
      settings.block_normal_config = true;
    };

    mkNeovim = userSettings: inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      settings = lib.recursiveUpdate baseSettings userSettings;
    };

  in {
    packages = {
      Neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
        inherit pkgs;
        settings = baseSettings;
      };

      Neovim-King = mkNeovim (import ./_king.nix { inherit pkgs; });
    };
  };
}
