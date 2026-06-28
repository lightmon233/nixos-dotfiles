{ config, pkgs, lib, ... }:

{
  # make sure feh is installed
  home.packages = [pkgs.feh];

  xsession = {
    enable = true;
    # content in initExtra will be executed as shell script after login
    initExtra = ''
    WALLPAPER_DIR="${config.home.homeDirectory}/Wallpapers"
    FEHBG="${config.home.homeDirectory}/.fehbg"

    if [ -x "$FEHBG" ]; then
      echo "Found record of last wallpaper, now reloading..."
      # "$FEHBG" &
      wal -R
    else
      echo "Not finding .fehbg record, setting up random wallpaper or pure color as fallback..."
      if [ -d "$WALLPAPER_DIR" ]; then
        # ${pkgs.feh}/bin/feh --bg-fill --randomize "$WALLPAPER_DIR" &
        wal -i "$WALLPAPER_DIR" &
        xrdb -merge ~/.cache/wal/colors.Xresources
        xdotool key alt+F5
      else 
        mkdir -p "$WALLPAPER_DIR"
        ${pkgs.feh}/bin/feh --bg-color "#2e3440" &
      fi
    fi
    '';
  };
}
