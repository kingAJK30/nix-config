{ inputs, pkgs, ... }:

{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;

    extraPackages = with pkgs; [
      vscode-langservers-extracted # For HTML
      emmet-ls                     # For HTML
    ];

    extras = {
      lang.nix.enable = true;
      lang.python = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };
  };
}
