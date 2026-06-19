{ ... }:

{
  programs.regreet = {
    enable = true;
    settings = {
      # Currently broken: https://github.com/NixOS/nixpkgs/issues/532825
      # background = {
      #   path = ./wallpapers/artemis2.jpg;
      #   fit = "Cover";
      # };
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
  };
}
