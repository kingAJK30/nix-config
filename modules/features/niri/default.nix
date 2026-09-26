{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.Niri;
    };
  };

  perSystem = { pkgs, lib, ... }: {
    packages.Niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      settings = {
	spawn-at-startup = [ ];
	
	xwayland-satellite.path =
	  lib.getExe pkgs.xwayland-satellite;

	input.keyboard = {
	  xkb.layout = "us";
	};

	layout.gaps = 5;

	binds = {
	  "Mod+Return".spawn-sh = lib.getExe pkgs.foot;
	  "Mod+Q".close-window = { };
	};
      };
    };
  };
}
