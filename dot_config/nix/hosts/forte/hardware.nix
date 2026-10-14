{ lib, modulesPath, hostName, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  # GCE のディスクは virtio-scsi (N1/N2/E2 等) か NVMe (C3/N4 等) で繋がる
  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_scsi" "virtio_blk" "nvme" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  # 起動ログを get-serial-port-output で読めるようにする
  boot.kernelParams = [ "console=ttyS0,115200n8" ];

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = lib.mkForce false;
  networking.hostName = hostName; # Define your hostname.

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
