{ self, ... }: {
  flake.nixosModules.user-king = { pkgs, ... }: {
    users.users.king = {
      isNormalUser = true;
      description = "King";
      extraGroups = [ "wheel" "networkmanager" ];
      
      packages = [
        self.packages.${pkgs.system}.Foot-King
      ];
    };
  };
}
