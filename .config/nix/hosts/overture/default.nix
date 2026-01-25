{ inputs, ... }:
let
  inherit (inputs) nixos-hardware nixpkgs home-manager disko nix-monitored;
  username = "peacock";
  system = "aarch64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
nixpkgs.lib.nixosSystem {
  system = system;
  specialArgs = inputs // { inherit system pkgs username; };
  modules = [
    disko.nixosModules.disko
    nix-monitored.nixosModules.default
    nixos-hardware.nixosModules.raspberry-pi-4
    ./disk.nix
    ./hardware.nix
    ../../nixos

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = {
        imports = [
          ../../home-manager
          ../../home-manager/platforms/nixos.nix
          ../../home-manager/presets/tiny.nix
        ];
      };
    }
  ];
}
