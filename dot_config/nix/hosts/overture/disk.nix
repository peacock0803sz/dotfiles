{ lib, ... }: {
  disko.devices = {
    disk = {
      sd = {
        device = "/dev/disk/by-id/mmc-EE4S5_0x2dc155b8";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "512M";
              type = "EF00";
              priority = 1;
              content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; };
            };
            root = {
              name = "root";
              size = "100%";
              content = { type = "filesystem"; format = "ext4"; mountpoint = "/"; };
            };
          };
        };
      };
    };
  };
}
