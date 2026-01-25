{ inputs, ... }:
let
  inherit (inputs) nixos-hardware nixpkgs home-manager disko nix-monitored;
  username = "peacock";
  system = "x86_64-linux";
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
    nixos-hardware.nixosModules.gmktec-nucbox-g3-plus
    ../../nixos
    ./hardware.nix
    ./disk.nix
    ./nixos.nix

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit pkgs; };
      home-manager.users."${username}" = {
        imports = [
          ../../home-manager
          ../../home-manager/platforms/nixos.nix
          ../../home-manager/presets/small.nix
        ];
      };
    }
  ];
}
