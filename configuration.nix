###############################################################################
# Configuration.nix
###############################################################################

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./user.nix
      ./networking.nix
      ./environment.nix
      ./services.nix
      ./programs.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.supportedFilesystems = lib.mkForce [ "vfat" "fat32" "exfat" "ext4" "btrfs" ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      # Automatically reboot to enroll the keys in the firmware
      autoReboot = true;
    };
  };
  
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };


  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Extra Kernel Modules - v4l2loopback
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.initrd.systemd.enable = true;
  hardware.amdgpu.initrd.enable = true;
  hardware.enableRedistributableFirmware = true;


  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8 * 1024;
  }];

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  networking.hostName = "Pink";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Detroit";
  services.ntp.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  boot.blacklistedKernelModules = [ "nvidia" ];

  boot.kernelModules = [
    "v4l2loopback"
  ];

  security.polkit.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # Required for modern Intel GPUs (Xe iGPU and ARC)
      intel-media-driver     # VA-API (iHD) userspace
      vpl-gpu-rt             # oneVPL (QSV) runtime
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";     # Prefer the modern iHD backend
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";


  # Enable sound and Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig = {
      pipewire-pulse = {
        pulse.min.quantum = "1024/48000";
      };
    };
  };  

  # services.jack = {
  #   jackd.enable = true;
  #   alsa.enable = false;
  #   loopback.enable = true;
  # };

  # Disable root password
  users.users.root.hashedPassword = "!";

  # System packages
  environment.systemPackages = with pkgs; [
    wget
    pavucontrol
    networkmanagerapplet
    btop
    gitFull
    usbutils
    coreutils-full
    udiskie
    zip
    unzip
    bat
    eza
    playerctl
    nix-index
    lxqt.lxqt-policykit
    polkit_gnome
    tpm2-tss
  ];

  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts = {
    fontconfig.enable = true; # prevents font cache corruption
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira
      nerd-fonts.zed-mono
      nerd-fonts.ubuntu-sans
      nerd-fonts.ubuntu-mono
      nerd-fonts.hack
      nerd-fonts.victor-mono
      nerd-fonts.jetbrains-mono
      dejavu_fonts #required for bottles
    ];
  };

  # Uncomment if Bluetooth needed
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  services.blueman.enable = true;

  fonts.fontDir.enable = true;

  nix.settings.auto-optimise-store = true;

  environment = {
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
    variables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
    };  
  };
  
  system.stateVersion = "26.05"; # Did you read the comment?
}
