{ ... }: {
  flake.nixosModules.llm-prometheus = { lib, pkgs, ... }: {
    services.llama-cpp = lib.mkForce {
      enable = true;
      openFirewall = true;
      package = pkgs.llama-cpp.override { vulkanSupport = true; };
      port = 8080;
      extraFlags = [
        "--model" "/var/lib/models/Qwen3.8-27B-UD-Q4_K_XL.gguf"
        "--n-gpu-layers" "99"
        "--ctx-size" "65536"
        "--n-predict" "65536"
        "--parallel" "1"
        "--cache-type-k" "q8_0"
        "--cache-type-v" "q8_0"
      ];
    };
  };
}
