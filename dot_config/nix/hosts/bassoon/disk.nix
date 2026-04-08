{ lib, ... }: {
  disko.devices = {
    disk = {
      builtin = {
        device = "/dev/disk/by-id/ata-256GB_SSD_MP31B70706114";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = { name = "boot"; size = "1M"; type = "EF02"; };
            esp = {
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; };
            };
            root = {
              name = "root";
              size = "100%";
              content = { type = "lvm_pv"; vg = "pool"; };
            };
          };
        };
      };
      ST4000VN006 = {
        device = "/dev/disk/by-id/ata-ST4000VN006-3CW104_WW687YWG";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            all = {
              name = "all";
              size = "100%";
              content = { type = "filesystem"; format = "ext4"; mountpoint = "/mnt/Eggplants/ST4000VN006"; mountOptions = [ "defaults" "nofail" ]; };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "defaults" ];
            };
          };
        };
      };
    };
  };
}
