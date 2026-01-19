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
    ];
  };

  npmPkgs = pkgs.callPackage ./node2nix { inherit pkgs; };
  brewCasks = import ./brewCasks.nix;
  homeModules = [
    (import ./home.nix)
    (import ../../home-manager )
    (import ../../home-manager/platforms/darwin.nix )
    (import ../../home-manager/programs/alacritty.nix )
    (import ../../home-manager/programs/claude-code { inherit pkgs npmPkgs mcp-servers-nix; })
    (import ../../home-manager/programs/direnv.nix )
    (import ../../home-manager/programs/ghostty.nix )
    (import ../../home-manager/programs/neovim.nix )
    (import ../../home-manager/programs/tmux.nix )
    (import ../../home-manager/programs/wezterm.nix )
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
