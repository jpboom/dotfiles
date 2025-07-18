# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    decibels
    epiphany
    geary
    gnome-contacts
    gnome-console
    gnome-maps
    gnome-music
    gnome-tour
    simple-scan
    totem
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  services.plex = {
    enable = true;
    openFirewall = true;
    user="jpboom";
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jpboom = {
    isNormalUser = true;
    description = "Jesse Peereboom";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.users.jpboom = { pkgs, ... }: {
    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".accent-color = "teal";
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
      settings."org/gnome/desktop/interface".cursor-theme = "Posy_Cursor_Black";
      settings."org/gnome/desktop/interface".document-font-name = "IBM Plex Sans 12";
      settings."org/gnome/desktop/interface".font-name = "IBM Plex Sans 12";
      settings."org/gnome/desktop/interface".monospace-font-name = "IBM Plex Mono 12";
      settings."org/home/desktop/wm/preferences".titlebar-font = "IBM Plex Sans 12";
      settings."org/gnome/shell" = {
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          caffeine.extensionUuid
        ];
      };
      settings."org/gnome/mutter".experimental-features = ["variable-refresh-rate"];
    };
    programs.atuin = {
      enable = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        search_mode = "fuzzy";
      };
    };
    programs.bash.enable = true;
    programs.kitty = {
      enable = true;
      settings = {
        background_opacity = "0.85";
        background = "#000000";
        foreground = "#fcfcfa";
        cursor = "#fcfcfa";
        cursor_text_color = "#000000";
        selection_foreground = "#403e41";
        selection_background = "#fcfcfa";
        color0 = "#403e41";
        color8 = "#727072";
        color1 = "#ff6188";
        color9 = "#ff6188";
        color2 = "#a9dc76";
        color10 = "#a9dc76";
        color3 = "#ffd866";
        color11 = "#ffd866";
        color4 = "#fc9867";
        color12 = "#fc9867";
        color5 = "#ab9df2";
        color13 = "#ab9df2";
        color6 = "#78dce8";
        color14 = "#78dce8";
        color7 = "#fcfcfa";
        color15 = "#fcfcfa";
        wayland_titlebar_color = "background";
      };
    };
  
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };

  # Install firefox.
  programs.firefox.enable = true;
  
  # Install Steam.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    pkgs.atuin
    pkgs.deluge
    pkgs.discord
    pkgs.enpass
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.caffeine
    pkgs.ibm-plex
    pkgs.joplin-desktop
    pkgs.kitty
    pkgs.libreoffice
    pkgs.mpv
    pkgs.posy-cursors
    pkgs.spotify-player
    pkgs.wgnord
    # Temporary/Config pkgs
    pkgs.dconf-editor
  ];
  
  fonts.fontDir.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
