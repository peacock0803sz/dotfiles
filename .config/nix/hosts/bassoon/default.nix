{ inputs, ... }:
let
  inherit (inputs) nixos-hardware nixpkgs home-manager disko nix-monitored;
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
  specialArgs = inputs // { inherit system; };
  modules = [
    disko.nixosModules.disko
    nix-monitored.nixosModules.default
    nixos-hardware.nixosModules.gmktec-nucbox-g3-plus
    (nixpkgs + "/nixos/modules/misc/nixpkgs/read-only.nix")
    { nixpkgs.pkgs = pkgs; }
    ../../nixos
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
