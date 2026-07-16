{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
      rcat = "find . -type f -name \"*.nix\" -exec cat {} +";
    };
  };
}

