{ pkgs, glob, ... }:

{
  home.packages = with pkgs; [
    brave
  ];
}
