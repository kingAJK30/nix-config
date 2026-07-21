{
  config,
  lib,
  ...
}: {
  options.services.globalTerminal = lib.mkOption {
    type = lib.types.str;
    default = "alacritty";
    description = "The terminal used across the ecosystem.";
  };

  config = {
    programs.alacritty = {
      enable = true;
      settings = {
        font.size = 11;
      };
    };
  };
}
