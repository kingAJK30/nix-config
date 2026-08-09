{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    zoxide
    tmux
    just
    fzf
    ouch
    hyperfine
    tree
  ];
}
