let
  OPTS = [
    "compress=zstd:3"
    "ssd"
    "space_cache=v2"
    "discard=async"
  ];
in {

  fileSystems = {
    "/nix".neededForBoot = true;
    "/persist".neededForBoot = true;
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [ "size=30%" "mode=755" ];
  };

  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_2TB_S76ENL0X900209L";
    type = "disk";

    content = {
      type = "gpt";
      partitions = {
        bios = {
          name = "bios";
          size = "1M";
          type = "EF02";
        };
        boot = {
          name = "boot";
          size = "2G";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        luks = {
          name = "luks";
          size = "100%";

          content = {
            type = "luks";
            name = "crypted";
            settings.allowDiscards = true;

            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "subvol=persist"
                  ] ++ OPTS;
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "subvol=nix"
                  ] ++ OPTS ++ [
                    "noatime"
                  ];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "subvol=home"
                  ] ++ OPTS;
                };
              };
            };
          };
        };
      };
    };
  };

}
