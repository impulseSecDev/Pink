###############################################################################
# User account
###############################################################################
{ config, pkgs, inputs, lib, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alicia = {
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; 
    packages = with pkgs; [
    ];
  };

}
