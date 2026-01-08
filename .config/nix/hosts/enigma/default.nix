{ inputs, ... }:
let
  inherit (inputs) nixpkgs home-manager disko nix-monitored;
  username = "peacock";
  system = "x86_64-linux";
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
  specialArgs = inputs // { inherit system pkgs; };
  modules = [
    disko.nixosModules.disko
    nix-monitored.nixosModules.default
    ../../nixos/default.nix
    ../../nixos/desktop.nix

    ./hardware.nix
    ./disk.nix
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
