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
in
nix-darwin.lib.darwinSystem {
  modules = [
    home-manager.darwinModules.home-manager
    (import ../../nix-darwin { inherit system username hostName pkgs brewCasks nix-monitored; })
    (import ../../nix-darwin/lemonade.nix { inherit pkgs; })
    {
      home-manager.backupFileExtension = "bk.nix";
      home-manager.extraSpecialArgs = { inherit npmPkgs mcp-servers-nix; };
      home-manager.users.${username} = {
        imports = [
          ./home.nix
          ../../home-manager
          ../../home-manager/platforms/darwin.nix
          ../../home-manager/programs/alacritty.nix
          ../../home-manager/programs/aibo.nix
          ../../home-manager/programs/bat.nix
          ../../home-manager/programs/direnv.nix
          ../../home-manager/programs/ghostty.nix
          ../../home-manager/programs/lnav.nix
          ../../home-manager/programs/neovim.nix
          ../../home-manager/programs/tmux.nix
          ../../home-manager/programs/wezterm.nix
          ../../home-manager/programs/claude-code
          ../../home-manager/programs/codex
          ../../home-manager/programs/gemini
        ];

        home.packages = import ./packages.nix { inherit pkgs npmPkgs; };
      };
    }
  ];
}
