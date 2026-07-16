{ lib, pkgs, inputs, ... }:

let
  obnVersion = "02.03.00.99";
  obnSrc = inputs.open-bamboo-networking;

  obnTools = with pkgs; [ cmake pkg-config git gcc gnumake ];

  obnLibs = with pkgs; [
    openssl.dev openssl.out
    curl.dev curl.out
    zlib.dev zlib.out
    mosquitto
    uthash
  ];

  obnBuildEnv = pkgs.buildEnv {
    name = "obn-build-env";
    paths = obnLibs;
    ignoreCollisions = true;
  };
in
{
  home.packages = [
    (pkgs.symlinkJoin {
      name = "orca-slicer-wrapped";
      paths = [ pkgs.orca-slicer ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/orca-slicer \
          --set GDK_BACKEND x11 \
          --prefix GIO_EXTRA_MODULES : "${pkgs.glib-networking}/lib/gio/modules" \
          --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      '';
    })
    pkgs.openscad
    pkgs.kicad
    pkgs.jq
  ];

  home.activation.installOrcaBambuPlugin =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      BUILD_DIR="$HOME/.cache/open-bamboo-networking-build"
      STAMP="$BUILD_DIR/.built-${builtins.baseNameOf obnSrc}"
      PLUGIN_DIR="$HOME/.config/OrcaSlicer/plugins"
      CONF="$HOME/.config/OrcaSlicer/OrcaSlicer.conf"

      if [ -z "''${DRY_RUN_CMD:-}" ] && [ ! -f "$STAMP" ]; then
        echo "Building open-bamboo-networking (first run, needs network)..."
        rm -rf "$BUILD_DIR"
        mkdir -p "$BUILD_DIR"
        cp -r ${obnSrc}/. "$BUILD_DIR"
        chmod -R u+w "$BUILD_DIR"
        (
          cd "$BUILD_DIR"
          export PATH="${lib.makeBinPath obnTools}:$PATH"
          export CMAKE_PREFIX_PATH="${obnBuildEnv}"
          export PKG_CONFIG_PATH="${obnBuildEnv}/lib/pkgconfig"
          export CPATH="${obnBuildEnv}/include"
          export LIBRARY_PATH="${obnBuildEnv}/lib"
          export OPENSSL_ROOT_DIR="${pkgs.openssl.dev}"

          sed -i "s|/usr/include/utlist.h|${pkgs.uthash}/include/utlist.h|" configure

          ./configure \
            --client-type=orca_slicer \
            --with-version=${obnVersion} \
            --no-conf-patch \
            --prefix="$BUILD_DIR/install"
          make -C build -j"$(nproc)"
          make -C build install
        )
        touch "$STAMP"
      fi

      if [ -d "$BUILD_DIR/install/plugins" ]; then
        $DRY_RUN_CMD mkdir -p "$PLUGIN_DIR"
        for f in "$BUILD_DIR"/install/plugins/*.so; do
          base=$(basename "$f")
          case "$base" in
            libbambu_networking*)
              $DRY_RUN_CMD cp -f "$f" "$PLUGIN_DIR/libbambu_networking_${obnVersion}.so"
              ;;
            *)
              $DRY_RUN_CMD cp -f "$f" "$PLUGIN_DIR/$base"
              ;;
          esac
        done

        if [ -f "$CONF" ]; then
          $DRY_RUN_CMD ${pkgs.jq}/bin/jq \
            '.app.installed_networking = "true"
             | .app.network_plugin_version = "${obnVersion}"
             | .app.network_plugin_remind_later = "true"' \
            "$CONF" > "$CONF.obn-tmp" \
          && $DRY_RUN_CMD mv "$CONF.obn-tmp" "$CONF"
        fi
      fi
    '';
}
