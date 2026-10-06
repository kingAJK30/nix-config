{ ... }: {
  flake.nixosModules.attrs-base = { pkgs, ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    environment.systemPackages = with pkgs; [ git tree zip unzip ];
  };
}
