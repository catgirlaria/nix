{ pkgs, glob, ... }:

{
  home.packages = with pkgs; [
    brave
    tela-icon-theme
    
    # cli
    fastfetch
    bat
  ];
}
