{ pkgs, ... }:
let
  hyprland-conf = pkgs.writeText "hyprland-regreet-config.lua" ''
    hl.on("hyprland.start", function()
  	  hl.exec_cmd("${pkgs.regreet}/bin/regreet; hyprctl dispatch 'hl.dsp.exit()'")
    end)

    hl.config({
  	  misc = {
  	  	disable_hyprland_logo = true,
  	  	disable_splash_rendering = true,
        disable_hyprland_guiutils_check = true,
  	  },
    })
  '';
in
{
  programs.regreet = {
    enable = true;
    settings = {
      background.path = "/home/stack/wallpapers/artemis2.jpg";
    };
  };
  services.greetd.settings.default_session = {
    command = "dbus-run-session start-hyprland -- -c ${hyprland-conf}";
  };
}
