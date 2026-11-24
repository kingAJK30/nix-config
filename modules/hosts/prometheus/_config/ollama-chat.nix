{ ... }: {
  home-manager.sharedModules = [
    ({ config, ... }: { ollamaChatModel = "qwen3:8b"; })
  ];
}
