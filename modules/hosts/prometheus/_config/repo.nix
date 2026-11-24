{ ... }: {
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        repoPath = "${config.home.homeDirectory}/src/nix-refactor";
      }
    )
  ];
}
