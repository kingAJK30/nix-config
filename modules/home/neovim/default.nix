{ config, pkgs, inputs, ... }:

{
  imports = [
    ./options.nix
    ./theme.nix
    ./treesitter.nix
    ./telescope.nix
    ./lsp.nix
    ./completion.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    nixpkgs.source = inputs.nixpkgs;
  };
}
