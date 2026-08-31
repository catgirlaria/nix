{ pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;

  security.pam.services.plasmalogin.kwallet = {
    enable = true;
    package = pkgs.kdePackages.kwallet-pam;
  };
}
