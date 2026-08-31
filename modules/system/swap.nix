{
  swapDevices = [
    {
      device = "/persist/swapfile";
      size = 32 * 1024; # 32 GiB
    }
  ];

  # taken from gitlab.com/sofiablahaj/nix - thanks meow :3
  boot.kernelParams = [
    "zswap.enabled=1" # enables zswap
    "zswap.compressor=lz4" # compression algorithm
    "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
    "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
  ];
  boot.initrd.systemd.enable = true;
}
