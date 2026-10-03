{ self, inputs, ... }: {
  perSystem = { pkgs, lib, ... }: let
    
    baseSettings = {
      modes = "drun";
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

      Rofi-King = mkRofi (import ./_king.nix);
    };
  };
}
