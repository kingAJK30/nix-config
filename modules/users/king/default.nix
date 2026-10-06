{ self, inputs, ... }: {
  flake.nixosModules.user-king = { ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    users.users.king = {
      isNormalUser = true;
      description = "King";
      extraGroups = [ "wheel" "networkmanager" ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      users.king = {
	imports = (with self.modules.homeManager; [ foot sway ]) ++ [
	  ./config/_foot.nix
	  ./config/_sway.nix
	];
	home.stateVersion = "26.05";
      };
    };
  };
}
