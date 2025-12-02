{ inputs, ... }:
let
  inherit (inputs) nixos-hardware nixpkgs home-manager disko;
  username = "peacock";
  system = "aarch64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-overlay.overlays.default
    ];
  };
in
nixpkgs.lib.nixosSystem {
  system = system;
  specialArgs = inputs;
  modules = [
    disko.nixosModules.disko
    nixos-hardware.nixosModules.raspberry-pi-4
    ./disk.nix
    ./hardware.nix
    ./nixos.nix

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = {
        imports = [
          ../../home-manager/nixos.nix
        ];
        home.packages = import ./packages.nix { inherit pkgs; };
      };
    }
  ];
}
