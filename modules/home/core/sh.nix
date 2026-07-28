{
  ...
}:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
      rcat = "find . -type f -name \"*.nix\" -exec cat {} +";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
