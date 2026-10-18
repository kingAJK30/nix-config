{ ... }: {
  flake.nixosModules.llm-prometheus = { lib, pkgs, ... }: {
    # 1. Vulkan-accelerated llama-cpp service using Router Mode
    services.llama-cpp = lib.mkForce {
      enable = true;
      openFirewall = true;
      package = pkgs.llama-cpp.override { vulkanSupport = true; };
      port = 8080;
      extraFlags = [
        "--models-dir" "/var/lib/models"
        
        "--n-gpu-layers" "99"
        "--ctx-size" "4096"
        "--cache-type-k" "q8_0"
        "--cache-type-v" "q8_0"
      ];
    };

    services.open-webui = {
      enable = true;
      port = 3000;
      environment = {
        OPENAI_API_BASE_URL = "http://127.0.0.1:8080/v1";
        OPENAI_API_KEY = "not-needed";
        WEBUI_AUTH = "False";
        ENABLE_OLLAMA_API = "False";
      };
    };
  };
}
