{
  config,
  lib,
  ...
}: {
  options.services.globalMenu = lib.mkOption {
    type = lib.types.str;
    default = "rofi -show drun";
    description = "The launcher menu used across the ecosystem.";
  };

  config = {
    programs.rofi.enable = true;
  };
}
