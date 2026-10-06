{ ... }: {
  flake.nixosModules.amd = { pkgs, ... }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    boot.initrd.kernelModules = [ "amdgpu" ];

    environment.systemPackages = with pkgs; [ vulkan-tools mesa-demos ];
  };
}
