{ ... }: {
  flake.nixosModules.boot-systemd-boot = { ... }: {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.timeout = 3;
  };
}
