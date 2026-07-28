{
  config,
  lib,
  ...
}:
{
  options.services.globalTerminal = lib.mkOption {
    type = lib.types.str;
    default = "foot";
    description = "The terminal used across the ecosystem.";
  };

  config = {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=11";
        };
      };
    };
  };
}
