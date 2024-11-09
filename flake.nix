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
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    neovim-src = {
      url = "github:neovim/neovim";
      flake = false;
    };
    vim-src = {
      url = "github:vim/vim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, vim-src, neovim-src }:
    let
      username = "peacock";
      homeManagerStateVersion = "24.05";
    in
    {
      darwinConfigurations = (
        import ./.config/nix/hosts/darwin.nix {
          specialArgs = { inherit vim-src neovim-src homeManagerStateVersion; };
          inherit self username nixpkgs nix-darwin home-manager;
        }
      );
    };
}
