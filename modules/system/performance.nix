{ pkgs, ... }:

{
  services = {
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };

    scx.enable = true;
    scx.scheduler = "scx_lavd";
  };
}
