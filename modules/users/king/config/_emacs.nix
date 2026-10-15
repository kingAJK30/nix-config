{ ... }: {
  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom;
  };

  services.emacs = {
    enable = true;
  };

  home.shellAliases = {
    emacs = "emacsclient -t";
    emacsg = "emacsclient -c";
  };
}
