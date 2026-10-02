###############################################################################
# Programs
###############################################################################
{ config, pkgs, ... }:

{
  programs.java.enable = true;

  programs.nix-ld.enable = true;

  programs.coolercontrol.enable = true;

  programs.nano.enable = false;
  programs.neovim.defaultEditor = true;
  # Programs that require SUID wrappers or special user config
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
