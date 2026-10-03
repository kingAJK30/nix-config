{ self, inputs, ... }: {
  flake.nixosModules.attrs-development = { pkgs, ... }: {
    imports = [
      self.nixosModules.Neovim
      self.nixosModules.Foot
    ];

    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
