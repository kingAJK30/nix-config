{ self, inputs, ... }: {
  flake.nixosModules.prometheusConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.prometheusHardware
      self.nixosModules.user-king
      self.nixosModules.amd
      self.nixosModules.boot-systemd-boot

      self.nixosModules.attrs-base
#      self.nixosModules.attrs-development
      self.nixosModules.attrs-graphical

      self.nixosModules.sway
#      self.nixosModules.fonts
      self.nixosModules.steam
    ];

    networking.hostName = "prometheus";
    networking.networkmanager.enable = true;

    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";

    home-manager.users.king.wayland.windowManager.sway.config.output = {
      "DP-2"     = { mode = "1920x1080@239.760Hz"; pos = "0 0"; };
      "HDMI-A-1" = { mode = "1920x1080@74.986Hz";  pos = "1920 0"; };
    };

    nixpkgs.config.allowUnfree = true;
    hardware.enableRedistributableFirmware = true;

    system.stateVersion = "26.05";
  };
}
