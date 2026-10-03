{ self, inputs, ... }: {
  flake.nixosModules.prometheusConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.prometheusHardware
      self.nixosModules.user-king
      self.nixosModules.boot-systemd-boot
      self.nixosModules.Amd

      self.nixosModules.attrs-base
      self.nixosModules.attrs-graphical
      self.nixosModules.attrs-development

      self.nixosModules.niri
      self.nixosModules.rofi
    ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    
    hardware.enableRedistributableFirmware = true;
  };
}
