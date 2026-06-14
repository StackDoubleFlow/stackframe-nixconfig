{ ... }:

{
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = ./wallpapers/artemis2.jpg;
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
  };
}
