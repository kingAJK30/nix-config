{ config, inputs, ... }: {
  flake.modules.nixos.librewolf = { pkgs, ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.librewolf ];
  };

  flake.modules.homeManager.librewolf =
    { lib, options, ... }:
    let
      desktopFile = "librewolf.desktop";
    in
    {
      config = lib.mkMerge [
        {
          programs.librewolf = {
            enable = true;
            profiles.default.isDefault = true;

            settings = lib.mapAttrs (_: lib.mkDefault) {
              "webgl.disabled" = false;
              "privacy.clearOnShutdown.cookies" = false;
              "privacy.clearOnShutdown.history" = false;
              "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
              "network.cookie.lifetimePolicy" = 0;
              # "privacy.resistFingerprinting" = false; # uncomment if timezone/dark-mode quirks bother you
            };
          };

          xdg.mimeApps = {
            enable = true;
            defaultApplications = lib.mapAttrs (_: lib.mkDefault) {
              "text/html" = desktopFile;
              "x-scheme-handler/http" = desktopFile;
              "x-scheme-handler/https" = desktopFile;
              "x-scheme-handler/about" = desktopFile;
              "x-scheme-handler/unknown" = desktopFile;
            };
          };

          home.sessionVariables.BROWSER = lib.mkDefault "librewolf";
        }

        # only wire Stylix in if the host uses it
        (lib.mkIf (options ? stylix) {
          stylix.targets.librewolf.profileNames = [ "default" ];
        })
      ];
    };
}
