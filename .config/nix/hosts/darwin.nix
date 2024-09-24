{ self, username, nixpkgs, nix-darwin, home-manager, neovim-nightly-overlay, ... }:
let
  system = "aarch64-darwin";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [ neovim-nightly-overlay.overlays.default ];
  };
in
{
  darwin = nix-darwin.lib.darwinSystem {
    modules = [
      home-manager.darwinModules.home-manager
      (import ../nix-darwin { inherit self system username nixpkgs pkgs; })
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = import ../home-manager/darwin.nix {
          inherit pkgs system;
        };
      }
    ];
  };
}
