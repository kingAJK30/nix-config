{ self, ... }: {
  flake.modules.homeManager.attrs-development = {
    imports = with self.modules.homeManager; [ nvim ];
  };
}
