# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Use the GRUB EFI boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.grub.device = "nodev";
  users.users.root.initialHashedPassword = "";

  networking.hostName = "stackframe";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="US"
  '';

  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stack = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "adbusers" "docker" "dialout" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    packages = with pkgs; [];
  };

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    (google-chrome.override {
      # GTK4 is needed for fcitx popups to show
      # There is currently a bug in google-chrome (but not chromium) where we need to manually specify wayland otherwise we get a white screen
      # commandLineArgs = "--gtk-version=4 --ozone-platform=wayland";
    })
    firefox
    alacritty
    prismlauncher
    discord
    bemenu # wayland dmenu alternative
    grim # screenshot utility
    slurp # wayland screen region selector (for screenshots)
    wl-clipboard
    playerctl
    pamixer
    wob # wayland overlay bar
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
    usbutils # lsusb
    pciutils # lspci
    killall
    file
    dolphin
    breeze-icons
    btop
    spotify
    baobab
    pavucontrol
    gimp
    osu-lazer-bin
    python3
    clang
    clang-tools
    llvmPackages_latest.llvm
    ninja
    gnumake
    ghidra
    postman
    wireshark
    audacity
    exiftool
    wget
    glfw-wayland
    xorg.xeyes
    gnome.adwaita-icon-theme
    just
    unityhub
    libreoffice-qt
    hunspell # Spell-checker (used by libreoffice)
    # darling # MacOS Wine-like emulator 
    nix-output-monitor
    obsidian
    magic-vlsi
    klayout
    hyfetch
    blender
    unzip
    jdk17
    jdk22
    cryfs
    dotnetCorePackages.sdk_9_0
    signal-desktop
    blueberry

    # Dev Libraries
    wayland
  ];
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # For home-manager sway
  security.polkit.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # For gnome configuration
  programs.dconf.enable = true;

  programs.light.enable = true;
  services.upower.enable = true;
  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.login.enableGnomeKeyring = true;
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
    # TODO: https://nixos.wiki/wiki/PipeWire#Low-latency_setup
  };

  programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics.enable32Bit = true;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  programs.adb.enable = true;

  virtualisation.docker.enable = true;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
}

