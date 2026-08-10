{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modules.desktop.quickshell;
in
{
  options.modules.desktop.quickshell = {
    enable = lib.mkEnableOption "Quickshell desktop environment UI";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.quickshell
      pkgs.qt6.qtdeclarative
      pkgs.qt6.qtsvg
    ];

    xdg.configFile."quickshell" = {
      source = ./src;
      recursive = true;
    };

    wayland.windowManager.sway.config.startup = [
      { command = "quickshell"; }
    ];
  };
}
