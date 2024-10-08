
{ config, pkgs, lib, inputs, ... }:

{
  home.packages = with pkgs; [
    (google-chrome.override {
      # GTK4 is needed for fcitx popups to show
      commandLineArgs = "--gtk-version=4";
    })

    # Games
    (prismlauncher.override {
      jdks = [ jdk8 jdk17 jdk21 ];
    })
    osu-lazer-bin

    # Social
    vesktop
    signal-desktop

    # IDEs and other visual dev tools
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        rust-lang.rust-analyzer
        vscodevim.vim
        serayuzgur.crates
        tamasfe.even-better-toml
        llvm-vs-code-extensions.vscode-clangd
        vadimcn.vscode-lldb
        rust-lang.rust-analyzer
        ms-vscode-remote.remote-ssh
        mkhl.direnv
        bbenoist.nix
        eamodio.gitlens
      ];
    })
    jetbrains.idea-community
    ghidra
    graphviz

    # Dev tooling
    python3
    clang
    clang-tools
    llvmPackages_latest.llvm
    ninja
    gnumake
    inputs.qpm.outputs.packages."x86_64-linux".default

    # Dev Libraries
    glfw-wayland
    dotnetCorePackages.sdk_9_0
    wayland

    # TODO: Sort through these
    spotify
    obs-studio
    audacity
    gimp
    dolphin
    obsidian
    gephi
    via # Keyboard config editor
    quickemu
    baobab
    pavucontrol # TODO: audio module
    blueberry
    gparted

    libreoffice-qt
    hunspell # Spell-checker (used by libreoffice)
  ];

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
