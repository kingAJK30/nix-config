{ ... }: {
  flake.modules.nixos.base = { lib, ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    nix.optimise.automatic = true;

    nix.settings.warn-dirty = false;

    boot.loader.systemd-boot.configurationLimit = lib.mkDefault 5;

    services.fstrim.enable = true;
    services.btrfs.autoScrub.enable = true;

    networking.networkmanager.enable = true;
    i18n.defaultLocale = "en_US.UTF-8";
  };
}
