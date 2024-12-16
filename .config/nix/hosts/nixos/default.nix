{ inputs, ... }:
let
  inherit (inputs) nixpkgs home-manager;
  username = "peacock";
  system = "aarch64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
nixpkgs.lib.nixosSystem {
  system = system;
  specialArgs = inputs;
  modules = [
    ../../nixos
    ./hardware-configuration.nix

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = {
        imports = [
          ../../home-manager/base.nix
          ../../home-manager/headed.nix
        ];

        home.packages = import ./packages.nix {
          inherit pkgs;
          inherit (inputs) neovim-src;
        };
      };
    }
  ];
}
