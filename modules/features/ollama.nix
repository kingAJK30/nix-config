{ config, inputs, ... }: {
  flake.modules.nixos.ollama = { pkgs, lib, ... }: {
    services.ollama = {
      enable = true;
      package = lib.mkDefault pkgs.ollama-rocm;

      loadModels = lib.mkDefault [
        "qwen2.5-coder:3b"
	"qwen3:8b"
	"qwen3-vl-7B"
	"nomic-embed-text"
      ];

      environmentVariables = {
        OLLAMA_MAX_LOADED_MODELS = "2";
        OLLAMA_CONTEXT_LENGTH = "16384";
      };
    };
  };
}
