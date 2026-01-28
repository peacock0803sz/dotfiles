{ inputs }:
let
  inherit (inputs) nixpkgs nix-monitored mcp-servers-nix;

  system = "aarch64-darwin";
  username = "peacock";
  hostName = "nocturne";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-overlay.overlays.default
      inputs.llm-agents.overlays.default
    ];
  };

  brewCasks = import ./brewCasks.nix;
in
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
    (import ../../nix-darwin { inherit system username hostName pkgs brewCasks nix-monitored; })
    (import ../../nix-darwin/lemonade.nix { inherit pkgs; })
    {
      home-manager.backupFileExtension = "bk.nix";
      home-manager.extraSpecialArgs = { inherit pkgs hostName mcp-servers-nix; };
      home-manager.users.${username} = {
        imports = [
          ./home.nix
          ../../home-manager
          ../../home-manager/platforms/darwin.nix
          ../../home-manager/presets/huge.nix
        ];

      };
    }
  ];
}
