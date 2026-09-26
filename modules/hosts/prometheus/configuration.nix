{ self, inputs, ... }: {
  flake.nixosModules.prometheusConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.prometheusHardware
      self.nixosModules.user-king

      self.nixosModules.niri
      self.nixosModules.fonts
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
