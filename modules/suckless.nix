{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.st.overrideAttrs (_: {
      src = ../config/st;
      patches = [ ];
    }))
    (pkgs.dmenu.overrideAttrs (_: {
      src = ../config/dmenu;
      patches = [ ];
    }))
    (pkgs.dwmblocks.overrideAttrs (_: {
      src = ../config/dwmblocks;
      patches = [ ];
    }))
    slock
  ];

  xsession.initExtra = ''
    if [ "$XDG_CURRENT_DESKTOP" = "dwm" ] || [ "$XDG_CURRENT_DESKTOP" = "none+dwm" ]; then
      fcitx5 &
    fi
  '';
}
