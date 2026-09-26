{ self, inputs, ... }: {
  flake.nixosConfigurations.prometheus = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.prometheusConfiguration
    ];
  };
}
