{ self, inputs, ... }: {
  flake.nixosModules.Amd = { pkgs, lib, ... }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    boot.initrd.kernelModules = [ "amdgpu" ];

    environment.systemPackages = with pkgs; [
      clinfo
      mesa-demos
      vulkan-tools
      radeontop
      lact
    ];
  };
}
