{ ... }: {
  flake.modules.nixos.amd = { pkgs, lib, ... }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.amdgpu = {
      initrd.enable = lib.mkDefault true;
      opencl.enable = true;
    };

    hardware.enableRedistributableFirmware = lib.mkDefault true;

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
      vulkan-tools
      mesa-demos
      clinfo
    ];
  };
}
