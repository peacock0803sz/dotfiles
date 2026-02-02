{ inputs, ... }:
let
  inherit (inputs) nixpkgs mcp-servers-nix;
  username = "peacock";
  system = "x86_64-linux";
  hostName = "enigma";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-overlay.overlays.default
      inputs.nur.overlays.default
      inputs.llm-agents.overlays.default
    ];
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
    ../../nixos/default.nix
    ../../nixos/akkoma.nix
    ../../nixos/notizen.nix
    ../../nixos/lemonade.nix

    ./hardware.nix
    ./disk.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit hostName mcp-servers-nix; };
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
