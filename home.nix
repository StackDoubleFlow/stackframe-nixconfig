{ config, pkgs, lib, ... }:

{
  home.username = "stack";
  home.homeDirectory = "/home/stack";

  programs.fish = {
    enable = true;
    loginShellInit = ''
      if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec sway
      end
    '';
  };
  
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
  
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
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
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 32;
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons
    ];
  };

  programs.neovim.enable = true;
  
  programs.git = {
    enable = true;
    userName = "StackDoubleFlow";
    userEmail = "ojaslandge@gmail.com";
    aliases = {
      rc = "rebase --continue";
    };
    extraConfig = {
      pull.ff = "only";
      core.editor = "vim";
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
        profile.name = "left_monitor";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.5;
            position = "1920,0";
          }
          {
            criteria = "AOC 2279WH AHXH79A000647";
            position = "0,0";
            mode = "1920x1080@60Hz";
          }
        ];
      }
    ];
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
        position = "top";
        statusCommand = "while ~/scripts/sway_bar.sh; do sleep 1; done";
        colors = {
          statusline = "#ffffff";
          background = "#323232";
          inactiveWorkspace = {
            border = "#32323200";
            background = "#32323200";
            text = "#5c5c5c";
          };
        };
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

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}

