{ self, ... }: {
  flake.nixosModules.user-king = { pkgs, ... }: {
    users.users.king = {
      isNormalUser = true;
      description = "King";
      extraGroups = [ "wheel" "networkmanager" ];
      
      packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.Foot-King
	self.packages.${pkgs.stdenv.hostPlatform.system}.Rofi-King
	self.packages.${pkgs.stdenv.hostPlatform.system}.Neovim-King
      ];
    };
  };
}
