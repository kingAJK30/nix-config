{ self, inputs, ... }: {
  flake.nixosModules.Foot = { pkgs, lib, ... }: {
    programs.foot = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.Foot;
    };
  };

  perSystem = { pkgs, lib, ... }: let
    
    baseSettings = {
      scrollback = {
        lines = 10000;
        multiplier = 3.0;
      };
    };

    mkFoot = userSettings: inputs.wrapper-modules.wrappers.foot.wrap {
      inherit pkgs;
      settings = lib.recursiveUpdate baseSettings userSettings;
    };

  in {
    packages = {
      Foot = inputs.wrapper-modules.wrappers.foot.wrap {
        inherit pkgs;
        settings = baseSettings;
      };

      Foot-King = mkFoot (import ./_king.nix);
    };
  };
}
