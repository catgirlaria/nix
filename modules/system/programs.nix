{ pkgs, glob, ... }:

{

  security.polkit.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ glob.USER ]; # to set up polkit auth
  };

}
