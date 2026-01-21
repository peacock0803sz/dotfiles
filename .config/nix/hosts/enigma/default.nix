{ inputs, ... }:
let
  inherit (inputs) nixpkgs home-manager disko nix-monitored mcp-servers-nix;
  username = "peacock";
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-overlay.overlays.default
    ];
  };
  npmPkgs = pkgs.callPackage ./node2nix { inherit pkgs; };
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
      home-manager.extraSpecialArgs = { inherit npmPkgs mcp-servers-nix; };
      home-manager.users."${username}" = {
        imports = [
          ../../home-manager
          ../../home-manager/platforms/nixos.nix
          ../../home-manager/programs/aibo.nix
          ../../home-manager/programs/bat.nix
          ../../home-manager/programs/direnv.nix
          ../../home-manager/programs/neovim.nix
          ../../home-manager/programs/claude-code
        ];
        home.packages = import ./packages.nix { inherit pkgs; };
      };
    }
  ];
}
