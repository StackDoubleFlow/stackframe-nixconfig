{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    bemenu # wayland dmenu alternative
    grim # screenshot utility
    slurp # wayland screen region selector (for screenshots)
    wl-clipboard
    playerctl
    pamixer
    wob # wayland overlay bar

    xorg.xeyes # Used to check if apps are running in Wayland
  ];

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
    # TODO: Fix qt kde settings
    # This should fix Dolphin's folder view background,
    # but it doesn't look like kdeglobals gets generated.
    # I made the file manuaally for now: ~/.config/kdeglobals
    # kde.settings.kdeglobals.Colors.BackgroundNormal = "#2E2E2E";
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
      terminal = "alacritty";
      menu = "bemenu-run --binding vim --vim-esc-exits -c -l \"10 down\" -W 0.5";
      window.border = 0;
      output."eDP-1".scale = "1.5";
      defaultWorkspace = "workspace number 1";
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
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
      };
      input = {
        "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
          "click_method" = "clickfinger";
        };
        "1133:16465:Logitech_M510" = {
          "accel_profile" =  "flat";
          "pointer_accel" = "-0.2";
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
}