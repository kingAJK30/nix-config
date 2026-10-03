{ self, inputs, ... }: {
  flake.nixosModules.attrs-base = { pkgs, ... }: {
    imports = [
      self.nixosModules.Git
    ];

    environment.systemPackages = with pkgs; [
      zip
      unzip

      tree
    ];
  };
}
