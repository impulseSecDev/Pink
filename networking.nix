###############################################################################
# networking
###############################################################################
{ config, pkgs, ... }:

{

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = false;
    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = false;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1d"; # Default ban time for 1 day
    bantime-increment = {
      enable = true;
      formula = "ban.Time * 1.5"; # Simple formula to increase ban time by 50% for each offense
      maxtime = "1w"; # Maximum ban time of 1 week
      overalljails = true;
    };

    jails = {
      # Protects against SSH brute-force attacks.
      sshd = {
        enabled = true;
        settings = {
          journalmatch = "_SYSTEMD_UNIT=sshd.service";
          bantime = "2d"; # A longer ban time for SSH attacks
          findtime = 600; # 10 minutes
          maxretry = 3; # Very few retries to prevent password guessing
        };
      };
    };
  };

  environment.etc = {
    "fail2ban/filter.d/open-webui.conf".text = ''
      [Definition]
      failregex = .*POST /api/v1/auth/login.*401.*
      ignoreregex =
    '';
  };
}
