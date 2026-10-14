{ inputs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-staging;
  username = "peacock";
  system = "x86_64-linux";
  hostName = "forte";
  pkgs = import nixpkgs {
    inherit system;
    config = (import ../../nixpkgs.nix);
    overlays = [
      inputs.neovim-overlay.overlays.default
      inputs.nur.overlays.default
    ];
  };
  pkgs-staging = import nixpkgs-staging {
    inherit system;
    config.allowUnfree = true;
  };
in
nixpkgs.lib.nixosSystem {
  system = system;
  specialArgs = inputs // { inherit system username hostName; };
  modules = [
    { nixpkgs.pkgs = pkgs; }

    inputs.disko.nixosModules.disko
    inputs.nix-index-database.nixosModules.nix-index
    inputs.nix-monitored.nixosModules.default
    ../../nixos/default.nix
    ../../nixos/docker.nix
    ../../nixos/neovim.nix
    ../../nixos/lemonade.nix

    ./hardware.nix
    ./disk.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit hostName inputs pkgs-staging; };
      home-manager.users."${username}" = {
        imports = [
          ./home.nix

          ../../home-manager
          ../../home-manager/platforms/nixos.nix
          ../../home-manager/presets/large.nix
          # ../../home-manager/programs/agent-skills.nix
        ];
      };
    }
  ];
}
