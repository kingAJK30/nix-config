{
  description = "Flake of KingAJK30";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # primary unstable release
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05"; # alternate stable release

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
   
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    lazyvim.url = "github:pfassina/lazyvim-nix";

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    open-bamboo-networking = {
      url = "github:ClusterM/open-bamboo-networking";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, home-manager, mangowm, stylix, nixpkgs-stable, lazyvim, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
    nixosConfigurations = {
      prometheus = lib.nixosSystem {
	    inherit system;
	    specialArgs = { inherit inputs; };
	    modules = [
	      ./configuration.nix
        inputs.nix-flatpak.nixosModules.nix-flatpak
	      home-manager.nixosModules.home-manager
	      {
          home-manager.useGlobalPkgs = true;
	        home-manager.useUserPackages = true;
	        home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
	          inherit inputs;
	          pkgs-stable = import nixpkgs-stable {
              inherit system;
	          	config.allowUnfree = true;
	          };
	        };
          home-manager.users.king.imports = [ ./home.nix ];
	      }
	    ];
      };
    };
  };
}
