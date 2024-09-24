{
  description = "Peacock's Nix Configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # vim-src = {
    #   url = "github:vim/vim";
    #   flake = false;
    # };
  };

  outputs = { self, nixpkgs, neovim-nightly-overlay, nix-darwin, home-manager, ... }:
    let
      username = "peacock";
    in
    {
      darwinConfigurations = (
        import ./.config/nix/hosts/darwin.nix {
          inherit self username nixpkgs nix-darwin home-manager neovim-nightly-overlay;
        }
      );
    };
}
