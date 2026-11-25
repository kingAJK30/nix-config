{ config, ... }: {
  flake.modules.nixos.quickshell = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.quickshell ];

    # Needed for the control center's Bluetooth toggle (services/Bluetooth.qml):
    # provides bluetoothd and the bluetoothctl binary it polls.
    hardware.bluetooth.enable = true;
  };

  flake.modules.homeManager.quickshell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      color = config.lib.stylix.colors.withHashtag;
      font = config.stylix.fonts;

      home = config.home.homeDirectory;
      configDir = "${config.repoPath}/modules/features/quickshell";
    in
    {
      options.repoPath = lib.mkOption {
        type = lib.types.str;
        description = "Absolute path to this repo's working copy, for live-editable config links.";
      };

      options.ollamaChatModel = lib.mkOption {
        type = lib.types.str;
        default = "qwen3:8b";
        description = "Ollama model used by the dynamic island's ask-ollama mode.";
      };

      config = {
        home.packages = [
          pkgs.quickshell
          pkgs.curl
          pkgs.cava
        ];

        wayland.windowManager.sway.config.startup = lib.mkIf config.wayland.windowManager.sway.enable [
          { command = "${pkgs.quickshell}/bin/quickshell"; }
        ];

        xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink configDir;

        home.file."${lib.removePrefix "${home}/" configDir}/theme.json".text = builtins.toJSON {
          wallpaper = toString config.stylix.image;
          colors = {
            bg = color.base00;
            surface = color.base01;
            dim = color.base04;
            fg = color.base05;
            border = color.base05;
            accent = color.base0D;
            red = color.base08;
            yellow = color.base0A;
            green = color.base0B;
          };
          fonts = {
            mono = font.monospace.name;
            size = font.sizes.desktop;
          };
        };

        home.file."${lib.removePrefix "${home}/" configDir}/ask.json".text = builtins.toJSON {
          model = config.ollamaChatModel;
        };
      };
    };
}
