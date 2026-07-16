{ inputs, pkgs, ... }:

{
  imports = [ inputs.mangowm.nixosModules.mango ];

  programs.mango.enable = true;
  services.displayManager.ly.enable = true;
}
