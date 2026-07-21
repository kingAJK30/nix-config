{
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr
    ];
    extraPackages32Bit = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };
}
