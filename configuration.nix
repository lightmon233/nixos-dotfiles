{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/vim.nix
      ./modules/picom.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-btw"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # wifi
  networking.wireless = {
    enable = true;
    userControlled = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = ./config/dwm;
    };
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

  users.users.light = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  users.users.light = {
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    tmux
    wget
    git
    alacritty
    brightnessctl # for screen brightness
    pamixer # for volume control
  ];

  environment.etc = {
    "tmux.conf".source = ./.tmux.conf;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05"; 

}

