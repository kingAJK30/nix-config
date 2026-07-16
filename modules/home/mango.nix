{ inputs, pkgs, lib, ... }:

{
  # ============================================================
  # PACKAGES
  # Options: https://search.nixos.org/packages
  # ============================================================
  
  home.packages = with pkgs; [
    awww			# wallpaper daemon
    swaynotificationcenter	# notification daemon
    grim			# screenshot tool
    slurp			# screen region selector
    wl-clipboard		# clipboard
    cliphist			# clipboard history
    xdg-desktop-portal-wlr	# wayland portal (screen share, file picker)
    xdg-desktop-portal-gtk	# GTK portal backend
    rofi			# app launcher
    font-awesome		# waybar icons
    nerd-fonts.symbols-only	# MORE waybar icons
    cava			# audio visualizer
    playerctl			# media control for mediaplayer module
  ];

  # ============================================================
  # MANGOWM COMPOSITOR
  # Docs: https://mangowm.github.io/docs/visuals
  # ============================================================
  
  wayland.windowManager.mango = {
    enable = true;

    autostart_sh = ''
      awww-daemon &
      sleep 0.5 && awww img $(find ~/.dotfiles/wallpapers -type f | shuf -n1) &
      waybar &
      swaync &
      wl-paste --watch cliphist store &
    '';

    settings = {
      tagrule = [
        "id:1,layout_name:dwindle"
        "id:2,layout_name:dwindle"
        "id:3,layout_name:dwindle"
        "id:4,layout_name:dwindle"
        "id:5,layout_name:dwindle"
      ];

      monitorrule = [
      "name:^DP-2$,width:1920,height:1080,refresh:280,x:0,y:0"
      "name:^HDMI-A-2$,width:1920,height:1080,refresh:75,x:1920,y:0"
      ];

      # ============================================================
      # THEMING
      # Docs: https://mangowm.github.io/docs/visuals/theming
      # ============================================================
      
      borderpx = 2;	# border width in pixels
      gappih = 8;	# horizontal inner gap (between windows)
      gappiv = 8;	# vertical inner gap
      gappoh = 12;	# horizontal outer gap (between windows and screen edges)
      gappov = 12;	# vertical outer gap

      # Border colors (customize to match palette)
      focuscolor   = "0xc66b25ff";   # active window border
      bordercolor  = "0x444444ff";   # inactive window border
      urgentcolor  = "0xad401fff";   # urgent window border
      rootcolor    = "0x1e1e2eff";   # root/background color

      # ============================================================
      # EFFECTS
      # Docs: https://mangowm.github.io/docs/visuals/effects
      # ============================================================
     
      border_radius = 8;		# window corner radius in pixels
      no_radius_when_single = 0;	# disable radius if only one window is visible.

      # Blur (high performance cost)
      blur = 1;				# enable window blur
      blur_layer = 1; 			# enable blur for layer surfaces (like bars/docks)
      blur_optimized = 1;		# caches blur background to reduce GPU usage
      blur_params_radius = 5;		# strength (radius) of blur
      blur_params_noise = "0.02";	# blur noise level
      blur_params_brightness = "0.9";	# blur brightness adjustment
      blur_params_contrast = "0.9";	# blur contrast adjustment
      blur_params_saturation = "1.2";	# blur saturation adjustment

      # Shadows
      shadows = 1;			# enable shadows
      shadow_only_floating = 1;		# only draw shadows for floating windows (saves performance)
      shadows_size = 12;		# size of shadow
      shadows_blur = 15;		# shadow blur amount
      shadows_position_x = 0;		# shadow x offset
      shadows_position_y = 0;		# shadow y offset
      shadowscolor = "0x00000088";	# color of shadow
      
      # Opacity
      focused_opacity = "1.0";
      unfocused_opacity = "1.0"; 

      # ============================================================
      # ANIMATIONS
      # Docs: https://mangowm.github.io/docs/visuals/animations
      # ============================================================
     
      animations = 1;			# enable animations
      animation_type_open = "slide";	# type of open animation (slide, zoom, fade, none)
      animation_type_close = "slide";	# type of close animation (slide, zoom, fade, none)
      animation_duration_open = 300;	# duration of open animation (milliseconds)
      animation_duration_close = 300;	# duration of close animation (milliseconds)

      # ============================================================
      # KEYBINDS
      # Docs: https://mangowm.github.io/docs/bindings/keys
      # ============================================================
    
      bind = [
        # Terminal
        "SUPER,Return,spawn,alacritty"

	      # Launcher
        "SUPER,Space,spawn,rofi -show drun"

        # Clipboard history picker
        "SUPER,V,spawn,cliphist list | rofi -dmenu | cliphist decode | wl-copy"

	      # Screenshot (region --> clipboard)
        "SUPER+SHIFT,P,spawn,grim -g \"$(slurp)\" - | wl-copy"

      	# Screenshot (fullscreen --> clipboard)
        "SUPER,P,spawn,grim - | wl-copy"

        # Notification center toggle
        "SUPER,N,spawn,swaync-client -t"

      	# Window management
        "SUPER,q,killclient,"
        "SUPER,f,togglefullscreen,"
        "SUPER,t,togglefloating"
        "SUPER,r,reload_config"
        "SUPER,m,quit,"

        # Move window to next/previous monitor
        "SUPER+SHIFT,Right,tagmon,next"
        "SUPER+SHIFT,Left,tagmon,prev"
        
        # Focus next/previous monitor
        "SUPER,period,focusmon,next"
        "SUPER,comma,focusmon,prev"

        # Focus
        "SUPER,Left,focusdir,left"
        "SUPER,Right,focusdir,right"
        "SUPER,Up,focusdir,up"
        "SUPER,Down,focusdir,down"

	# Move floating windows
        "SUPER+ALT,Left,smartmovewin,left"
        "SUPER+ALT,Right,smartmovewin,right"
        "SUPER+ALT,Up,smartmovewin,up"
        "SUPER+ALT,Down,smartmovewin,down"

	# Resize windows
        "SUPER+CTRL,Left,smartresizewin,left"
        "SUPER+CTRL,Right,smartresizewin,right"
        "SUPER+CTRL,Up,smartresizewin,up"
        "SUPER+CTRL,Down,smartresizewin,down"

        # Tags (switch)
        "SUPER,1,view,1"
        "SUPER,2,view,2"
        "SUPER,3,view,3"
        "SUPER,4,view,4"
        "SUPER,5,view,5"

	# Tags (move window to tag)
        "SUPER+SHIFT,1,tag,1"
        "SUPER+SHIFT,2,tag,2"
        "SUPER+SHIFT,3,tag,3"
        "SUPER+SHIFT,4,tag,4"
        "SUPER+SHIFT,5,tag,5"

	# Volume (requires wpctl from pipewire)
        "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%+"
        "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%-"
        "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SINK@ toggle"
      ];
    };
  };

  # ============================================================
  # WAYBAR (status bar)
  # Docs: https://wiki.nixos.org/wiki/Waybar
  # Options: https://mynixos.com/home-manager/options/programs.waybar
  # ============================================================

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";		# decide of bar is displayed in front or behind windows
	passthrough = false;
	position = "top";	# bar position (top, bottom, left, right)
	height = 38;		# height used by bar
	margin-top = 0;
        margin-right = 0;
        margin-left = 0;
	margin-bottom = 0;
	spacing = 0;		# size of gaps between modules
        exclusive = true;
        ipc = true;		# tell Waybar to use dwl protocol

	# Modules that define what is on the bar
	modules-left	= [ "custom/app-launcher" "ext/workspaces" "custom/mediaplayer" "cava" ];
	modules-center	= [ "clock" ];
	modules-right	= [ "tray" "cpu" "spacer" "memory" "spacer" "pulseaudio" "custom/power" ];

	"ext/workspaces" = {
	  format = "{icon}";
          ignore-hidden = true;
          on-click = "activate";
          on-click-right = "deactivate";
          sort-by-id = true;
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
	  };
	};

        "custom/app-launcher" = {
          format = "";
          tooltip = true;
          tooltip-format = "Application Launcher";
          on-click = "rofi -show drun";
        };

        "custom/mediaplayer" = {
          format = "{}";
          max-length = 30;
          escape = true;
          exec = "playerctl metadata --format '{{artist}} - {{title}}' -F";
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
        };

        "cava" = {
          framerate = 30;
          autosens = 1;
          sensitivity = 0.4;
          bars = 14;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 10000;
          hide_on_silence = true;
          format_silent = "quiet";
          method = "pipewire";
          source = "auto";
          stereo = true;
          reverse = false;
          bar_delimiter = 0;
          monstercat = true;
          waves = true;
          noise_reduction = 0.27;
          input_delay = 2;
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          actions = {
            on-click-right = "mode";
          };
	};

        "clock" = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %d %B  %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            on-scroll = 1;
          };
        };

	"cpu" = {
          format = " {usage}%";
          interval = 2;
        };

	"memory" = {
          format = " {}%";
          interval = 5;
        };

	"spacer" = {
          format = " | ";
	};

	"pulseaudio" = {
	  format = "{volume}% {icon}";
          format-muted = "0%";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            default = [ "" "" ];
          };
          scroll-step = 1;
          on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
	};

	"tray" = {
	  icon-size = 16;
          spacing = 8;
        };

	"custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "rofi -show power-menu";
	};
      };
    };

    # Basic CSS styling (Customize to match theme)
    style = ''
      * {
        border: none;
        border-radius: 0;
        }

      window#waybar {
        background-color: transparent;
      }
      
      .modules-left,
      .modules-center,
      .modules-right {
        border-radius: 8px;
        margin: 4px 4px;
        padding: 0 4px;
      }
      
      .modules-left   { margin-left:  8px; border-left: 1px solid;      }
      .modules-center { min-width: 0;      border-left: 1px solid;   }
      .modules-right  { margin-right: 8px; border-left: 1px solid; }
      
      tooltip {
        border-radius: 3px;
        padding: 8px 12px;
      }
      
      
      #workspaces,
      #clock,
      #custom-app-launcher,
      #pulseaudio,
      #custom-power,
      #custom-mediaplayer,
      #cava,
      #cpu,
      #memory,
      #tray {
        padding: 0 5px;
        margin: 3px 1px;
      }
      
      #workspaces { padding: 0 1px; }
      
      #workspaces button {
        background-color: transparent;
        padding: 2px 7px;
        margin: 0 1px;
        border-radius: 2px;
        transition: all 0.15s ease;
      }
      
      #custom-app-launcher,
      #custom-power {
        padding: 0 6px;
      }
      
      
      #custom-power { transition: all 0.15s ease; }
      
      #clock {
        padding: 0 8px;
      }
      
      #cava {
        padding: 0 4px;
      }
      
      #tray { padding: 0 3px; }
      #tray > .needs-attention { -gtk-icon-effect: highlight; }
    '';
  };

  # ============================================================
  # ROFI (app launcher)
  # Options: https://mynixos.com/home-manager/options/programs.rofi
  # ============================================================

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    font = lib.mkForce "JetBrainsMono Nerd Font 12";

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "Papirus";
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Windows";
      drun-display-format = "{name}";
      disable-history = false;
    };
  };

  # ============================================================
  # XDG Portal
  # Required for screen sharing, file pickers, and more
  # ============================================================

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
}
