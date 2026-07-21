{
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home/apps/
    ../../modules/home/core/
    ../../modules/home/desktop/
    ../../modules/home/dev/
  ];

  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "king";
    homeDirectory = "/home/king";
  };

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
