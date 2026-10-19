
{ inputs, self, ... }: {
  flake.darwinModules.macbookConfiguration = { ... }: {
    imports = [
      inputs.home-manager.darwinModules.home-manager
    ];

    nixpkgs.pkgs = import inputs.nixpkgs-darwin {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    networking.hostName = "aaron-macbook";
    system.primaryUser = "aaron";

    users.users.aaron.home = "/Users/aaron";

    system.stateVersion = 5;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      backupFileExtension = "before-home-manager";

      users.aaron = {
        imports = (with self.modules.homeManager; [
          attrs-base
	  attrs-development
          emacs
          git
        ]) ++ [
	  ../../users/king/config/_emacs.nix
	];

        home = {
          username = "aaron";
          stateVersion = "25.11";
        };

        programs.zsh.enable = true;
      };
    };
  };
}

