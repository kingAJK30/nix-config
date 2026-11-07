{ inputs, ... }: {
  flake.modules.homeManager.quickshell = { config, lib, pkgs, ... }: {
    home.packages = [ pkgs.quickshell ];

    xdg.configFile."quickshell".source = ./config;

    xdg.configFile."base16/colors.json".text =
      builtins.toJSON (lib.mapAttrs (_: c: "#${c}") config.my.colors);

    systemd.user.services.quickshell = {
      Unit = {
        Description = "Quickshell desktop shell";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.quickshell}/bin/quickshell";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
