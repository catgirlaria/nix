{ inputs, glob, ... }:

{
  home = {
    username = glob.USER;
    homeDirectory = "/home/${glob.USER}";
    stateVersion = "26.05";
  };
  # OwO!
  nixowos.enable = true;
  # broken
  nixowos.overlays.hyfetch = false;

  programs.fish.enable = true;

  imports = [
    (inputs.import-tree ../../modules/home)
  ];
}
