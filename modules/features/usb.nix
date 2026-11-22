{ config, ... }: {
  flake.modules.nixos.usb = { ... }: {
    services.udisks2.enable = true;
    services.gvfs.enable = true;

    boot.supportedFilesystems = [
      "ntfs"
      "exfat"
    ];

    home-manager.sharedModules = [ config.flake.modules.homeManager.usb ];
  };

  flake.modules.homeManager.usb = { lib, ... }: {
    services.udiskie = {
      enable = true;
      automount = lib.mkDefault true;
      notify = lib.mkDefault true;
      tray = lib.mkDefault "auto";
    };
  };
}
