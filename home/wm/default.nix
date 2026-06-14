{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Hyprland stuff
    hyprlauncher

    grim # screenshot utility
    slurp # wayland screen region selector (for screenshots)
    wl-clipboard
    playerctl
    brightnessctl

    xeyes # Used to check if apps are running in Wayland

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
    size = 24;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;

    configType = "lua";
    extraConfig = builtins.readFile ./hyprland.lua;
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
