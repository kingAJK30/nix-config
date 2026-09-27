{ self, inputs, ... }: {
  flake.nixosModules.Name = { pkgs, lib, ... }: {
    programs.name = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.Name;
    };
  };

  perSystem = { pkgs, lib, ... }: let
    packages.Name = inputs.wrapper-modules.wrappers.name.wrap {
      inherit pkgs;

      baseSettings = {

      };

    mkName = userSettings: inputs.wrapper-modules.wrappers.name.wrap {
      inherit pkgs;
      settings = lib.recursiveUpdate baseSettings userSettings;
    };

  in {
    packages = {
      Name = inputs.wrapper-modules.wrappers.name.wrap {
        inherit pkgs;
        settings = baseSettings;
      };

      Name-User = mkName (import ./user.nix);
    };
  };
}
