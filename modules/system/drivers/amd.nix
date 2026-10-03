{ self, inputs, ... }: {
  flake.nixosModules.Amd = { pkgs, lib, ... }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmqtm
      ];
    };

    boot.initrd.kernelModules = [ "amdgpu" ];

    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.AmdTools
    ];
  };

  perSystem = { pkgs, lib, ... }: let

    baseSettings = {
    };

  in {
    packages = {
      AmdTools = inputs.wrapper-modules.wrappers.generic.wrap {
        inherit pkgs;
        settings = baseSettings;
        packages = with pkgs; [
          clinfo
          glxinfo
          vulkan-tools
          radeontop
          lact
        ];
      };
    };
  };
}
