
{ inputs, self, ... }: {
  flake.darwinConfigurations.macbook =
    inputs.nix-darwin.lib.darwinSystem {
      modules = [
        self.darwinModules.macbookConfiguration
      ];
    };
}

