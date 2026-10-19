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
      	programs.bash.enable = true;

      	imports = (with self.modules.homeManager; [
      	  attrs-base
      	  attrs-development
      	  attrs-graphical
      	  emacs
      	  rofi
      	  sway
      	]) ++ [
      	  ./config/_foot.nix
      	  ./config/_sway.nix
      	  ./config/_git.nix
      	  ./config/_rofi.nix
      	  ./config/_emacs.nix
          ./config/_opencode.nix
      	];
      	home.stateVersion = "25.11";
      };
    };
  };
}
