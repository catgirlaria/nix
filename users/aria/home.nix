{ inputs, pkgs, glob, ... }:

{
  home.username = glob.USER;
  home.homeDirectory = "/home/${glob.USER}";

  # OwO!
  nixowos.enable = true;
  # broken
  nixowos.overlays.hyfetch = false;

  programs.fish.enable = true;
  
  imports = [
    (inputs.import-tree ../../modules/home)
  ];

  home.stateVersion = "26.05";
}
