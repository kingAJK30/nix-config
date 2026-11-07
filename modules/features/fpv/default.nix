{ ... }: {
  flake.nixosModules.fpv = { ... }: {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    services.udev.extraRules = ''
      # STM32 Virtual COM Port & DFU Mode (Betaflight / FPV Flight Controllers)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", TAG+="uaccess"
    '';
  };

  flake.modules.homeManager.fpv = { pkgs, ... }: {
    home.packages = [
      (pkgs.writeShellScriptBin "betaflight-configurator" ''
        exec env GDK_BACKEND=x11 appimage-run ${./betaflight-configurator.AppImage} "$@"
      '')
    ];

    xdg.desktopEntries.betaflight-configurator = {
      name = "Betaflight Configurator";
      comment = "Configurator for Betaflight flight control system";
      exec = "betaflight-configurator";
      terminal = false;
      categories = ["Utility" "Development"];
      type = "Application";
    };
  };
}
