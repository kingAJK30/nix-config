{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/core
    ../../modules/system/display
    ../../modules/system/gaming
    ../../modules/system/hardware/amd.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
    ];
    config = {
      allowUnfree = true;
    };
  };

  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
  ];

  environment.sessionVariables.XDG_DATA_DIRS = [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      substituters = [ "https://cuda-maintainers.cachix.org" ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dgv7yl7uJL7hHS42cAxNsIsZea8N5KeeJ68A7iFXv4="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    channel.enable = false;
  };

  networking.hostName = "prometheus";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;

  time.timeZone = "America/Los_Angeles";
  systemd.coredump.enable = true;
  programs.dconf.enable = true;

  users.users = {
    king = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
      ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
