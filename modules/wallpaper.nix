{ config, pkgs, lib, ... }:

let
  wallpaperDir = "${config.home.homeDirectory}/Wallpapers";
in
{
  # make sure feh is installed
  home.packages = [pkgs.feh];

  xsession = {
    enable = true;
    # content in initExtra will be executed as shell script after login
    initExtra = ''
    ${pkgs.feh}/bin/feh --bg-fill --randomize ${wallpaperDir}/* &
    '';
  };
}
