{ pkgs, config, ... }:

{
  home.packages = [ pkgs.libnotify ];
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        height = "(50, 100)";
        origin = "top-right";
        offset = "(6, 30)";
        transparency = 8;
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
