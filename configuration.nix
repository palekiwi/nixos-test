# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.envfs.enable = true;


  networking.hostName = "nixos-test"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "Asia/Taipei";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_TW.UTF-8";
    LC_IDENTIFICATION = "zh_TW.UTF-8";
    LC_MEASUREMENT = "zh_TW.UTF-8";
    LC_MONETARY = "zh_TW.UTF-8";
    LC_NAME = "zh_TW.UTF-8";
    LC_NUMERIC = "zh_TW.UTF-8";
    LC_PAPER = "zh_TW.UTF-8";
    LC_TELEPHONE = "zh_TW.UTF-8";
    LC_TIME = "zh_TW.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
    };
    desktopManager.gnome.enable = false;

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };
  };

  services.displayManager = {
    defaultSession = "none+awesome";
    autoLogin = {
      enable = false;
      user = "ygt";
    };
  };

  # Enable the GNOME Desktop Environment.

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ygt = {
    isNormalUser = true;
    description = "ygt";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBFOyIzj48/XjyTC9B6HL7oxkIcGtxNgCaSpje+lldrlqb1Vmo2KGdlkHFSSDYkvOYzNgoE9ywKi7kYrvUXJ4SXhtqKu1VmYzYY8o2/aCgMY3Y1qmgCAvDsgec1imL3mCdCO447Iim+ckmlrAboSK8zBEGvBrEI2PMKLAStFf6zycJ4vJA94778GxpcA25g6mp/WHsKp1QvELLl/mL3I9z+SDoCSR7BK2vu6xgQfuJP+BepKzlHpZlpZF4OkGi9VAEsNxjSV0QbFTsL0Q04hrySzGi39b0eRe1AvWo/jFCtzS9BqM78NI4Ii8PP3PL3UUXgctqDwiLhSZaYVvFMR13LjJW1W1qe1KXbum6Q4+/YlWAaJ9322035aZRq0NzQgmZbC6wvcQDBVQru6NcZy1nnCGwJ77mLPm+nM+XIA5JzsBNCnMVVpa/tmC28fPbe0Z6tkJNeU53sCv5rQDg/kVagrZ2RP5Renf4PzJx8ps8ew8Q31nKXZcZ/Qb1eBFgqVubmvUGXC1C6RlfhkWOX/0oBsp7nI9nDeqa7wNJBJ29TMr/LQ6m1ZzblFZY91n2EsSGxM7RbBWTY2FS6xwXgM+AIdBNrU1Kn6F2mhlcuzGSbfQnLCEtr5HRxItJSu6XGx11Ps79yXHWbFai84V9777Xz8WftAeRoEcBixDrNXJmsw== cardno:15_196_430"
    ];
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    gnupg
    python3
    rsync
    tree
    wget
    zsh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.tailscale.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
 
 virtualisation.docker.enable = true;
}
