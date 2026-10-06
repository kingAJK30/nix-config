{ lib, ... }: {
  flake.modules.homeManager.foot = {
    programs.foot = {
      enable = true;
      settings = {
        scrollback.lines = 10000;
        main.font = lib.mkDefault "monospace:size=11";
      };
    };
  };
}
