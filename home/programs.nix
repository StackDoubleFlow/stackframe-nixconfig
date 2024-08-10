
{ config, pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    loginShellInit = ''
      if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec sway
      end
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "44c521ab292f0eb659a9e2e1b6f83f5f0595fcbd";
          sha256 = "sha256-85iU1QzcZmZYGhK30/ZaKwJNLTsx+j3w6St8bFiQWxc=";
        };
      }
    ];
    shellAliases = {
      c = "code . && exit";
      ll = "ls -Alh";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal = {
        family = "FiraCode Nerd Font";
        style = "Regular";
      };
    };
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
}