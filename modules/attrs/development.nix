{ self, inputs, ... }: {
  flake.nixosModules.attrs-development = { pkgs, ... }: {
    imports = with self.nixosModules; [ llm ];

    environment.systemPackages = with pkgs; [
      wl-clipboard
      nvtopPackages.amd
      wget
    ];
  };

  flake.modules.homeManager.attrs-development = { pkgs, ... }: {
    imports = with self.modules.homeManager; [ ];

    home.packages = with pkgs; [
      cargo
      tree
      python312
      inputs.rcat.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
