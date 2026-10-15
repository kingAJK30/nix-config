{ self, ... }: {
  flake.nixosModules.attrs-base = { pkgs, ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    environment.systemPackages = with pkgs; [ git tree zip unzip ];
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  flake.modules.homeManager.attrs-base = {
    imports = with self.modules.homeManager; [ git ];
  };

}
