{ config, pkgs, ... }:

{
  services.picom.enable = true;
  services.picom.settings = {
    backend = "glx";
    active-opacity = 1.0;
    inactive-opacity = 0.9;
    blur = {
      # method = "gaussian";
      # size = 20;
      # deviation = 10.0;
      method = "dual_kawase";
      strength = 6;
    };
    fading = true;
    fade-delta = 4;
    fade-in-step = 0.03;
    fade-out-step = 0.03;
    focus-exclude = [
      "class_g = 'dmenu'"
    ];
    blur-background-exclude = [
      "window_type = 'dock'"
      "window_type = 'desktop'"
    ];
    # corner-radius = 8.0;
    # round-borders = 1;
  };
}
