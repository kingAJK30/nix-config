{ config, ... }: {
  flake.modules.nixos.media = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.media ];
  };

  flake.modules.homeManager.media =
    { lib, ... }:
    let
      assign = app: types: lib.genAttrs types (_: lib.mkDefault app);
    in
    {
      programs.mpv = {
        enable = true;
        config = lib.mapAttrs (_: lib.mkDefault) {
          hwdec = "auto-safe";
          keep-open = "yes";
          save-position-on-quit = "yes";
        };
      };

      programs.zathura = {
        enable = true;
        options.selection-clipboard = lib.mkDefault "clipboard";
      };

      programs.imv.enable = true;

      xdg.mimeApps = {
        enable = true;
        defaultApplications =
          assign "mpv.desktop" [
            "video/mp4"
            "video/x-matroska"
            "video/webm"
            "video/quicktime"
            "video/x-msvideo"
            "video/mpeg"
            "video/ogg"
            "audio/mpeg"
            "audio/flac"
            "audio/ogg"
            "audio/x-wav"
            "audio/mp4"
          ]
          // assign "imv.desktop" [
            "image/png"
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/bmp"
            "image/tiff"
          ]
          // assign "org.pwmt.zathura.desktop" [ "application/pdf" ];
      };
    };
}
