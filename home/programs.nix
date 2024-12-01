
{ config, pkgs, lib, inputs, ... }:

let
  androidsdk = 
    (pkgs.androidenv.composeAndroidPackages {
      includeNDK = true;
    }).androidsdk;
in
{
  home.packages = with pkgs; [
    (google-chrome.override {
      # GTK4 is needed for fcitx popups to show
      commandLineArgs = "--gtk-version=4";
    })

    okular
    calibre

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
    gephi
    unityhub
    gitkraken

    # Dev tooling
    python3
    clang
    clang-tools
    llvmPackages_latest.llvm
    ninja
    gnumake
    cmake
    inputs.qpm.outputs.packages."x86_64-linux".default
    cargo-flamegraph
    powershell
    androidsdk

    # Dev Libraries
    glfw-wayland
    dotnetCorePackages.sdk_9_0
    wayland

    # System Management
    nautilus
    via # Keyboard config editor
    pavucontrol # TODO: audio module
    blueberry
    gparted
    baobab

    # Media Creation
    audacity
    gimp
    obs-studio

    # TODO: Sort through these
    spotify
    obsidian
    quickemu
    wine-staging
    winetricks

    libreoffice-qt
    hunspell # Spell-checker (used by libreoffice)
  ];

  home.sessionVariables = rec {
    ANDROID_HOME = "${androidsdk}/libexec/android-sdk";
    ANDROID_NDK_HOME = "${ANDROID_HOME}/ndk-bundle";
    LIBCLANG_PATH = "${pkgs.llvmPackages_latest.libclang.lib}/lib";
    # To fix: "Couldn't find a valid ICU package installed on the system."
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
  };

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
