{ inputs, ... }:
let
  inherit (inputs) nixpkgs;
  username = "peacock";
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
nixpkgs.lib.nixosSystem {
  system = system;
  specialArgs = inputs // { inherit system username; };
  modules = [
    { nixpkgs.pkgs = pkgs; }
    inputs.disko.nixosModules.disko
    inputs.nix-index-database.nixosModules.nix-index
    inputs.nix-monitored.nixosModules.default
    inputs.nixos-hardware.nixosModules.gmktec-nucbox-g3-plus
    ../../nixos
    ../../nixos/samba.nix
    ./hardware.nix
    ./disk.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { };
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
