{ lib, ... }: {
  disko.devices = {
    disk = {
      builtin = {
        device = "/dev/mmcblk0";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "512M";
              type = "EF02";
              content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot/firmware"; };
            };
            root = {
              name = "root";
              size = "100%";
              content = { type = "lvm_pv"; vg = "pool"; };
            };
          };
        };
      };
    };
  };
}
