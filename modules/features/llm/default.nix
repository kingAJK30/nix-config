{ ... }: {
  flake.nixosModules.llm = { pkgs, lib, ... }: {
    environment.systemPackages = [
      pkgs.llama-cpp
    ];

    services.llama-cpp = {
      enable = lib.mkDefault false;
      port = 8080;
    };
  };
}
