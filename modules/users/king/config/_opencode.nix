{ config, lib, pkgs, ... }:

{
  xdg.configFile."opencode/opencode.json" = {
    text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      provider = {
        prometheus-local = {
          npm = "@ai-sdk/openai-compatible";
          name = "Prometheus Local";
          options = {
            baseURL = "http://127.0.0.1:8080/v1";
            apiKey = "not-needed";
          };
          models = {
            "Meta-Llama-3.1-8B-Instruct-Q8_0" = {
              name = "Llama 3.1 8B Q8 (Vulkan Local)";
              limit = {
                context = 32768;
                output = 8192;
              };
            };
            "Qwen3.8-27B-UD-Q4_K_XL" = {
              name = "Qwen 3.8 27B UD Q4_K_XL (Vulkan Local)";
              limit = {
                context = 32768;
                output = 8192;
              };
            };
            "Qwen3-Coder-30B-A3B-Instruct-Q4_K_M" = {
              name = "Qwen 3 Coder 30B (Vulkan Local)";
              limit = {
                context = 32768;
                output = 8192;
              };
            };
          };
        };
      };
      model = "prometheus-local/Qwen3-Coder-30B-A3B-Instruct-Q4_K_M";
    };
  };  
}
