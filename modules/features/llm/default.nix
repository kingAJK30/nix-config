{ ... }: {
  flake.nixosModules.llm = { pkgs, lib, ... }: {
    environment.systemPackages = [
      pkgs.llama-cpp
      pkgs.aider-chat
    ];

    services.llama-cpp = {
      enable = lib.mkDefault false;
      port = 8080;
    };
  };
}
