{ config, pkgs, ... }:

{
  xsession.initExtra = ''
    dwmblocks &
  '';
}
