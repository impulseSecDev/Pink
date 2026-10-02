###############################################################################
# services
###############################################################################
{config, lib, pkgs, ... }:

{
  services.udisks2.enable = true;
  
  services.flatpak.enable = true;

  services.hardware.openrgb = { 
    enable = true; 
    package = pkgs.openrgb-with-all-plugins; 
    motherboard = "amd"; 
    server.port = 6742; 
  };

  services.printing = {
    enable = true;
    cups-pdf = {
      enable = true;
      instances.pdf.settings = {
        Out = "/home/alicia/prints";
      };
    };
  };

  services.tailscale = {
    enable = true;
  };
}
