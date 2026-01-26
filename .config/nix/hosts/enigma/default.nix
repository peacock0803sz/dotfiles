{ inputs, ... }:
let
  inherit (inputs) nixpkgs mcp-servers-nix;
  username = "peacock";
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-overlay.overlays.default
      inputs.llm-agents.overlays.default
    ];
  };
in
nixpkgs.lib.nixosSystem {
  system = system;
  specialArgs = inputs // { inherit system pkgs username; };
  modules = [
    inputs.disko.nixosModules.disko
    inputs.nix-index-database.nixosModules.nix-index
    inputs.nix-monitored.nixosModules.default
    ../../nixos/default.nix
    ../../nixos/desktop.nix
    ../../nixos/notizen.nix
    ../../nixos/lemonade.nix

    ./hardware.nix
    ./disk.nix
    ./nixos.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit pkgs mcp-servers-nix; };
      home-manager.users."${username}" = {
        imports = [
          ../../home-manager
          ../../home-manager/platforms/nixos.nix
          ../../home-manager/presets/large.nix
        ];
      };
    }
  ];
}
