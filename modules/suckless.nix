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
}
