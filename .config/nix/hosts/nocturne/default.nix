{ inputs }:
let
  inherit (inputs) nix-darwin home-manager nixpkgs nix-monitored mcp-servers-nix;

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
nix-darwin.lib.darwinSystem {
  modules = [
    home-manager.darwinModules.home-manager
    (import ../../nix-darwin { inherit system username hostName pkgs brewCasks nix-monitored; })
    (import ../../nix-darwin/lemonade.nix { inherit pkgs; })
    {
      home-manager.backupFileExtension = "bk.nix";
      home-manager.extraSpecialArgs = { inherit pkgs mcp-servers-nix; };
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
