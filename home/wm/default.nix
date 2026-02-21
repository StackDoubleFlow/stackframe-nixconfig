{ config, pkgs, lib, ... }:

let
  discordWorkspace = "  Discord";
  spotifyWorkspace = " Spotify";
in {
  home.packages = with pkgs; [
    # Hyprland stuff
    hyprlauncher

    bemenu # wayland dmenu alternative
    grim # screenshot utility
    slurp # wayland screen region selector (for screenshots)
    wl-clipboard
    playerctl
    pamixer
    wob # wayland overlay bar

    xorg.xeyes # Used to check if apps are running in Wayland

    # Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    corefonts
  ];
  fonts.fontconfig.enable = true;

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
  
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 32;
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      export QT_QPA_PLATFORM=wayland
      export XDG_SESSION_DESKTOP=sway
    '';
    config = rec {
      # Logo key.
      modifier = "Mod4";
      terminal = "alacritty msg create-window || alacritty";
      menu = "bemenu-run --binding vim --vim-esc-exits -c -l \"10 down\" -W 0.5";
      output."eDP-1".scale = "1.5";
      defaultWorkspace = "workspace number 1";
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
      assigns = {
        "${discordWorkspace}" = [{ app_id = "vesktop|Element"; }];
        "${spotifyWorkspace}" = [{ app_id = "spotify"; }];
      };
      keybindings = lib.mkOptionDefault {
        # Volume control
        "XF86AudioLowerVolume" = "exec pamixer -d 5 && pamixer --get-volume > $SWAYSOCK.wob";
        "XF86AudioRaiseVolume" = "exec pamixer -i 5 && pamixer --get-volume > $SWAYSOCK.wob";
        "XF86AudioMute" = "exec pamixer --toggle-mute";
        # Media control
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        # Brightness control
        "XF86MonBrightnessUp" = "exec light -A 5 && light -G | cut -d'.' -f1 > $SWAYSOCK.wob";
        "XF86MonBrightnessDown" = "exec light -U 5 && light -G | cut -d'.' -f1 > $SWAYSOCK.wob";
        # Application shortcuts
        "XF86AudioMedia" = "exec osu!";
        "${modifier}+Shift+m" = "exec prismlauncher -l 1.20.4";
        # Screenshots
        "print" = "exec grim -g \"$(slurp)\" - | wl-copy --type image/png";
        # Application-specific workspaces
        "${modifier}+Shift+d" = "workspace ${discordWorkspace}";
        "${modifier}+Shift+f" = "workspace ${spotifyWorkspace}";
      };
      input = {
        "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
          "click_method" = "clickfinger";
	        "tap" = "enabled";
        };
        "1133:16465:Logitech_M510" = {
          "accel_profile" =  "flat";
          "pointer_accel" = "-0.2";
        };
        "1133:16394:Logitech_M325" = {
          "accel_profile" =  "flat";
          "pointer_accel" = "-0.1";
        };
        "1133:49291:Logitech_G502_HERO_Gaming_Mouse" = {
          "pointer_accel" = "-0.5";
        };
      };
      startup = [
        {
          # Wayland overlay bar for sound and brightness level
          command = "mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | wob";
        }
        {
          command = "exec fcitx5";
        }
      ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "default";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.5;
          }
        ];
      }
      {
        profile.name = "right_monitor";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.5;
            position = "0,0";
          }
          {
            criteria = "AOC 2279WH AHXH79A000647";
            mode = "1920x1080@60Hz";
            position = "1504,0";
          }
        ];
      }
    ];
  };

  programs.waybar = {
    enable = true;
    settings.main = {
      height = 20;
      position = "bottom";
      modules-left = ["sway/workspaces" "sway/mode"];
      modules-right = ["network" "wireplumber" "battery" "clock" "tray"];

      battery = {
        format = "{icon}  {capacity}%";
        format-icons = ["" "" "" "" ""];
      };
      clock = {
        format = "{:%a, %b %d, %I:%M %p}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
      };
      network = {
        interface = "wlp1s0";
        format-wifi = "  {essid}";
        format-disconnected = "󰖪 No Wifi";
        tooltip-format-wifi = "{essid} ({signalStrength}%) ";
        tooltip-format-disconnected = "Disconnected";
      };
      wireplumber = {
        format = "{icon}  {volume}%";
        format-muted = "";
        on-click = "helvum";
        format-icons = ["" "" ""];
      };
      tray.spacing = 10;
    };
    style = builtins.readFile ./waybar.css;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "alacritty";
      "$menu" = "hyprlauncher";

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, C, killactive"
        "$mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, Space, togglefloating,"
        "$mainMod, Q, exec, $menu"
        "$mainMod, F, fullscreen, 1"
        "SUPER_SHIFT, F, fullscreen"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, S, togglespecialworkspace, spotify"
        "$mainMod, D, togglespecialworkspace, discord"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mainMod, code:1${toString i}, workspace, ${toString ws}"
              "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86MonBrightnessUp, exec, light -A 5"
        ",XF86MonBrightnessDown, exec, light -U 5"
      ];

      # Bar setup
      exec-once = [
        "ashell"
        # "[workspace special:spotify silent] spotify"
        # "[workspace special:discord silent] vesktop"
      ];

      windowrule = [
        "match:class spotify, workspace special:spotify"
        "match:class vesktop, workspace special:discord"
      ];

      monitor = "eDP-1, 2256x1504@60.00Hz, 0x0, 1.45";
      "debug:disable_scale_checks" = "true";

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];
    };
  };

  programs.ashell = {
    enable = true;
    settings = {
      position = "Bottom";
      modules = {
        "left" = [ "Workspaces" "MediaPlayer" ];
        "center" = [ "WindowTitle" ];
        "right" = [ "Tray" [ "Clock" "Privacy" "Settings" ] ];
      };
    };
  };
}
