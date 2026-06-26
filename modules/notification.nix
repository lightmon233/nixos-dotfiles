{ pkgs, config, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monito = 0;
        follow = "mouse";
        width = 300;
        height = 300;
        oigin = "top-right";
        offset = "10x50";
        transparency = 10;
        frame_color = "#81a2be";
        font = "JetBrainsMono Nerd Font 10";
      };
      urgency_normal = {
        background = "#282a2e";
        foreground = "#c5c8c6";
        timeout = 10;
      };
    };
  };
}
