{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/system/mango.nix
      ./modules/system/audio.nix
      ./modules/system/gaming.nix
    ];
  
  nixpkgs.config.allowUnfree = true; # allow unfree packages like Steam
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "prometheus";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";
  nix.settings = { max-jobs = 2; cores = 0; };  

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  services.xserver.enable = true;
  services.printing.enable = true;
  programs.gamemode.enable = true;
  programs.dconf.enable = true;

  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;

  systemd.coredump.enable = true;

  # NVIDIA DRIVERS!!!
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = false;
  };

  users.users.king = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
    packages = with pkgs; [
      tree
    ];
  };

  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [ "cuda-maintainers.cachix.org-1:0dgv7yl7uJL7hHS42cAxNsIsZea8N5KeeJ68A7iFXv4=" ];
  };

  services.flatpak = {
    enable = true;
    remotes = [{ name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }];
    packages = [ "com.orcaslicer.OrcaSlicer" ];
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    gh
    fastfetch
    python3
  ];


  networking.firewall = {
    allowedUDPPorts = [ 2021 1990 ];
    allowedTCPPorts = [ 990 8883 6000 2024 2025 ];
    extraCommands = ''
      iptables -I INPUT -m pkttype --pkt-type multicast -j ACCEPT
      iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT
      iptables -I INPUT -p udp -m udp --match multiport --dports 1990,2021 -j ACCEPT
    '';
  };

  system.stateVersion = "26.11";
}

