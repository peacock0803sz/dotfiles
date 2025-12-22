{ inputs }:
let
  inherit (inputs) nix-darwin home-manager nixpkgs nix-monitored mcp-servers-nix;

  system = "aarch64-darwin";
  username = "peacock";
  hostName = "arpeggio";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.nur.overlays.default
      inputs.neovim-overlay.overlays.default
      inputs.vim-overlay.overlays.default
    ];
  };

  npmPkgs = pkgs.callPackage ./node2nix { inherit pkgs; };
  brewCasks = import ./brewCasks.nix;
  homeModules = [
    (import ./home.nix)
    (import ../../home-manager/base.nix)
    (import ../../home-manager/headed.nix)
    (import ../../home-manager/darwin.nix)
    (import ../../home-manager/agents/claude-code { inherit pkgs npmPkgs mcp-servers-nix; })
    (import ../../home-manager/agents/codex { inherit pkgs npmPkgs mcp-servers-nix; })
    (import ../../home-manager/agents/gemini { inherit pkgs npmPkgs mcp-servers-nix; })
  ];
in
nix-darwin.lib.darwinSystem {
  modules = [
    home-manager.darwinModules.home-manager
    (import ../../nix-darwin { inherit system username hostName pkgs brewCasks nix-monitored; })
    {
      home-manager.backupFileExtension = "bk.nix";
      home-manager.users.${username} = {
        imports = homeModules;

        home.packages = import ./packages.nix { inherit pkgs npmPkgs; };
      };
    }
  ];
}
