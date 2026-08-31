# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, inputs, glob, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      (inputs.import-tree ../../modules/system)
    ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://attic.xuyh0120.win/lantian"
      "https://cache.puppygirls.net/main"
    ];

    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "main:OiT7TySueZMWxt1dpP7/SVwyhOwWu4L11tm1QhT2Qd8="
    ];
  };

  # NOTE: Why are flakes still experimental?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      devices = [ "nodev" ];
    };
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
    kernelParams = [

    ];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
  };

  networking = {
    hostName = glob.HOSTNAME;
    networkmanager.enable = true;
    nftables.enable = true;
    firewall.allowPing = false;
  };

  time.timeZone = glob.TZ;

  i18n = {
    defaultLocale = glob.LOCALE;
    extraLocaleSettings = {
      LC_ADDRESS = glob.LOCALE;
      LC_IDENTIFICATION = glob.LOCALE;
      LC_MEASUREMENT = glob.LOCALE;
      LC_MONETARY = glob.LOCALE;
      LC_NAME = glob.LOCALE;
      LC_NUMERIC = glob.LOCALE;
      LC_PAPER = glob.LOCALE;
      LC_TELEPHONE = glob.LOCALE;
      LC_TIME = glob.LOCALE;
    };
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    firewalld.enable = true;
  };

  programs.fish.enable = true;

  users.users = {
    ${glob.USER} = {
      isNormalUser = true;
      hashedPasswordFile = "/persist/passwd";
      extraGroups = [
        "wheel"
        "networkmanager"
        "input"
        "render"
        "video"
      ];
      shell = pkgs.fish;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];


  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

