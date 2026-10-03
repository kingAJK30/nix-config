{ self, inputs, ... }: {
  flake.nixosModules.prometheusConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.prometheusHardware
      self.nixosModules.user-king
      self.nixosModules.Amd

      self.nixosModules.niri
      self.nixosModules.fonts
      self.nixosModules.rofi
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
