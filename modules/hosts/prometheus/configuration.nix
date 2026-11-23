{ inputs, config, ... }:
let
  features = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations.prometheus = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.home-manager.nixosModules.home-manager
      features.prometheusHardware
      ./_config

      # --- core ---
      features.base
      features.polkit
      features.amd
      features.audio
      features.fonts
      features.cli
      features.git
      features.zsh
      features.usb
      features.media

      # --- desktop ---
      features.sway
      features.swaync
      features.ly
      features.rofi
      features.desktop-utils
      features.stylix
      features.foot
      features.starship
      features.thunar
      features.yazi
      features.borders
      features.cursor
      features.quickshell

      # --- development ---
      features.nvim
      features.claude
      features.ollama

      # --- misc ---
      features.gaming
      features.engineering
      features.librewolf

      {
        # --- identity ---
        networking.hostName = "prometheus";
        system.stateVersion = "26.05";

        # --- user ---
        users.users.king = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
        };
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
          users.king.home.stateVersion = "26.05";
        };

        # --- hardware / boot ---
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # --- basics ---
        time.timeZone = "America/Los_Angeles";
      }
    ];
  };
}
