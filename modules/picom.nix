{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    # shadow = true;
    # fade = true;
  };
}
