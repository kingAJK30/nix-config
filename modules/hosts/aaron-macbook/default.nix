
{ inputs, self, ... }: {
  flake.darwinConfigurations.aaron-macbook =
    inputs.nix-darwin.lib.darwinSystem {
      modules = [
        self.darwinModules.macbookConfiguration
      ];
    };
}

