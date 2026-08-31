{ pkgs, ... }:

{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    modesetting.enable = true;
    package = pkgs.nvidia_cachyos;
  };
}
