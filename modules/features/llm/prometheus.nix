{ ... }: {
  flake.nixosModules.llm-prometheus = { lib, pkgs, ... }: {
    environment.sessionVariables = {
      OPENAI_API_BASE = "http://127.0.0.1:8080/v1";
      OPENAI_API_KEY = "not-needed";
    };

    services.llama-cpp = lib.mkForce {
      enable = true;
      openFirewall = true;
      package = pkgs.llama-cpp.override { vulkanSupport = true; };
      port = 8080;
      extraFlags = [
        "--models-dir" "/var/lib/models"
        "--models-max" "1"
        "--api-key" "not-needed"
        "--n-gpu-layers" "99"
        "--ctx-size" "16384"
        "--context-shift"
        "--cache-type-k" "q4_0"
        "--cache-type-v" "q4_0"
        "--flash-attn" "on"
      ];
    };

    systemd.services.llama-cpp.environment = {
      XDG_CACHE_HOME = "/var/cache/llama-cpp";
      MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp";
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
