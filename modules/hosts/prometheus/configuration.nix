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
      features.waybar
      features.desktop-utils
      features.stylix
      features.foot
      features.starship
      features.thunar
      features.yazi
      features.borders
      features.cursor

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

          users.king.programs.git = {
            settings = {
              user = {
                name = "KingAJK30";
                email = "86845258+kingAJK30@users.noreply.github.com";
              };
            };
          };

          users.king.wayland.windowManager.sway.config.output = {
            "DP-2" = {
              mode = "1920x1080@239.760Hz";
              pos = "0 0";
            };
            "HDMI-A-1" = {
              mode = "1920x1080@74.986Hz";
              pos = "1920 0";
            };
          };
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
