{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.mangowm.hmModules.mango
    inputs.nixvim.homeModules.nixvim
    inputs.stylix.homeModules.stylix
    ./modules/home/sh.nix
    ./modules/home/mango.nix
    ./modules/home/gaming.nix
    ./modules/home/engineering.nix
    ./modules/home/neovim.nix
    ./modules/home/yazi.nix
    ./modules/home/stylix.nix
    ./modules/home/davinci.nix
    ./modules/home/godot.nix
  ];

  home.username = "king";
  home.homeDirectory = "/home/king";

  home.packages = with pkgs; [
    firefox
    wlr-randr
    home-manager
    gcc
    clang-tools
    bear
    #(pkgs.blender.override {
    #  cudaSupport = true;
    #})
    unzip
    speedtest-cli
    obsidian
    vesktop
  ];

  home.file = {};

  home.sessionVariables = {
    XDG_DATA_DIRS = "/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.alacritty.enable = true;
  programs.home-manager.enable = true;
  programs.bash.enable = true;

  home.stateVersion = "26.05";
}
