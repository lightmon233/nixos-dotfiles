{ config, pkgs, ... }:

let
  polybar-themes-src = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "polybar-themes";
    rev = "master";
    sha256 = "sha256-f/54m7RJnqNW6eC/75IrnFxmSWTY+zd5epm6TQsYeYA=";
  };
in
{
  xsession.initExtra = ''
    if [ "$XDG_CURRENT_DESKTOP" = "dwm" ] || [ "$XDG_CURRENT_DESKTOP" = "none+dwm" ]; then
      dwmblocks &
    fi
  '';
  home.packages = with pkgs; [
    polybar
    calc
  ];
  home.file.".local/share/fonts".source = ../fonts;

  xdg.configFile."polybar" = {
    source = "${polybar-themes-src}/simple";
    recursive = true;
    onChange = ''
      chmod +x $HOME/.config/polybar/launch.sh
    '';
  };
}
