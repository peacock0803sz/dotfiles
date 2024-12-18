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
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    vim-src = {
      url = "github:vim/vim";
      flake = false;
    };
    neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      flake = {
        darwinConfigurations = {
          nocturne = import ./.config/nix/hosts/nocturne { inherit inputs; };
          toccata = import ./.config/nix/hosts/toccata { inherit inputs; };
        };
        nixosConfigurations = {
          nixos = import ./.config/nix/hosts/nixos { inherit inputs; };
        };
      };
      perSystem = { ... }: { };
    };
}
