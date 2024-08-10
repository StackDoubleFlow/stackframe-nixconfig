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
  systemd.services.NetworkManager-wait-online.enable = false;
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="US"
  '';

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # Set your time zone.
  time.timeZone = "America/Chicago";

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
  programs.fish.enable = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # My trusty editor
    vim

    # Nix Management
    just
    nix-output-monitor

    usbutils # lsusb
    pciutils # lspci
    fw-ectool
    killall
    file
    btop
    wget
    hyfetch
    unzip
    cryfs
  ];
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code-nerdfont
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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
    wlr.enable = true;
  };

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

  # Enable binary blobs
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  programs.steam.enable = true;
  programs.steam.package = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [
      libxkbcommon wayland
    ];
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics.enable32Bit = true;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  # I don't want it running by default
  systemd.services.tailscaled.enable = false;

  services.flatpak.enable = true;

  programs.adb.enable = true;

  virtualisation.docker.enable = true;

  hardware.keyboard.qmk.enable = true;
  services.udev.packages = [ pkgs.via ];

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
}

