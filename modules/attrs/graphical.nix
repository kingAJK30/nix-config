{ self, inputs, ... }: {
  flake.nixosModules.attrs-graphical = { pkgs, ... }: {
    imports = [
      self.nixosModules.fonts
      self.nixosModules.audio
    ];

    environment.systemPackages = with pkgs; [
      firefox
    ];
  };
}
