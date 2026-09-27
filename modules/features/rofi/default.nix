{ self, inputs, ... }: {
  flake.nixosModules.Rofi = { pkgs, lib, ... }: {
    programs.rofi = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.Rofi;
    };
  };

  perSystem = { pkgs, lib, ... }: let
    
    baseSettings = {
      modes = "drun";
      font = "jetbrains-mono 12";
      show-icons = false;
    };

    mkRofi = userSettings: inputs.wrapper-modules.wrappers.rofi.wrap {
      inherit pkgs;
      settings = lib.recursiveUpdate baseSettings userSettings;
    };

  in {
    packages = {
      Rofi = inputs.wrapper-modules.wrappers.rofi.wrap {
        inherit pkgs;
        settings = baseSettings;
      };

      Rofi-King = mkRofi (import ./king.nix);
    };
  };
}
