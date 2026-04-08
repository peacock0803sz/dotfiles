{ inputs, ... }: {
  imports = [ inputs.darwin-vz-nix.darwinModules.default ];

  services.darwin-vz = {
    enable = true;
    cores = 8;
    memory = 1024;
    diskSize = "32G";
    rosetta = true;
    idleTimeout = 180; # minutes (0 = disabled)
    kernelPath = "${inputs.darwin-vz-nix.packages.aarch64-linux.guest-kernel}/Image";
    initrdPath = "${inputs.darwin-vz-nix.packages.aarch64-linux.guest-initrd}/initrd";
    systemPath = "${inputs.darwin-vz-nix.packages.aarch64-linux.guest-system}";
  };
}
