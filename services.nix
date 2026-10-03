###############################################################################
# services
###############################################################################
{config, lib, pkgs, ... }:

{
  services.udisks2.enable = true;
  
  services.flatpak.enable = true;

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
