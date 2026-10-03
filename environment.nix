###############################################################################
#  Environment
###############################################################################
{ config, pkgs, inputs, ... }:

{
  security.polkit.enable = true;

  # Enable Desktop Environment
  services = {
    #displayManager.gddm.enable = true;
    xserver = {
      desktopManager.lxqt.enable = true;
      displayManager.lightdm.enable = true;
    };
  };  

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    lxqt.enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
  };

  security.rtkit.enable = true; 
}

