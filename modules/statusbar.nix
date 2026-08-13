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
    terminus_font_ttf
    icomoon-feather
    material-icons
    nerd-fonts.iosevka
    siji
  ];
  xdg.configFile."polybar" = {
    source = "${polybar-themes-src}/simple";
    recursive = true;
    onChange = ''
      chmod +x $HOME/.config/polybar/launch.sh
      chmod +x $HOME/.config/polybar/hack/launch.sh
      chmod +x $HOME/.config/polybar/hack/preview.sh
      chmod +x $HOME/.config/polybar/hack/scripts/checkupdates
      chmod +x $HOME/.config/polybar/hack/scripts/check-network
      chmod +x $HOME/.config/polybar/hack/scripts/*.sh
    '';
  };
}
