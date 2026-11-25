{ ... }: {
  home-manager.sharedModules = [
    ({ config, ... }: { programs.quickshell.ollamaChatModel = "qwen3:8b"; })
  ];
}
