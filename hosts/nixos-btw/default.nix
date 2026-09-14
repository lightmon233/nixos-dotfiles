{ config, lib, pkgs, waybar, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/vim.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  services.udisks2.enable = true; # This enables dolphin to see inserted usb disks

  networking.hostName = "nixos-btw"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # wifi
  networking.wireless = {
    enable = true;
    userControlled = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = ../../config/dwm;
    };
  };
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      i3status
      i3lock
    ];
  };
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };
  services.libinput = {
    enable = true;
    touchpad = {
    naturalScrolling = true;
    };
  };

  services.displayManager.ly.enable = true;

  services.blueman.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # withUWSM = true; # 可提供更好的systemd集成
  };

  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # 让electron/chromium优先用wayland
  };

  users.users.light = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      glibc
      util-linux
      openssl
      icu
      curl
    ];
  };

  users.users.light = {
    shell = pkgs.zsh;
  };

  # set up input method
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [
    "zh_CN.UTF-8/UTF-8"
    # "ja_JP.UTF-8/UTF-8"
  ];
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-rime
        fcitx5-mozc
        fcitx5-material-color
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    tmux
    wget
    git
    alacritty
    brightnessctl # for screen brightness
    pamixer # for volume control
    xdotool
    kitty
    rofi
    swaybg
    grim
    slurp
    wl-clipboard
    thunar
    pyprland
    rofi
    wlogout
    psmisc # for killall command
    waybar.packages.${pkgs.stdenv.hostPlatform.system}.waybar
    kdePackages.qtsvg
    kdePackages.kio # needed since 25.11
    kdePackages.kio-fuse #to mount remote filesystems via FUSE
    kdePackages.kio-extras #extra protocols support (sftp, fish and more)
    kdePackages.dolphin # This is the actual dolphin package
    ntfs3g
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  environment.etc = {
    "tmux.conf".source = ../../.tmux.conf;
  };

  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05"; 

}

