{ self, inputs, ... }: {
  flake.nixosModules.Name = { pkgs, lib, ... }: {
    programs.name = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.Name;
    };
  };

  perSystem = { pkgs, lib, ... }: {
    packages.Name = inputs.wrapper-modules.wrappers.name.wrap {
      inherit pkgs;

      settings = {

      };
    };
  };
}
