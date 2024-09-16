{
  description = "Peacock's Nix Configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # vim-src = {
    #   url = "github:vim/vim";
    #   flake = false;
    # };
  };

  # outputs = { nixpkgs, vim-src, neovim-nightly-overlay, flake-utils, ... }:
  outputs = { nixpkgs, neovim-nightly-overlay, home-manager, ... }:
    let
      defaltPkgs = { system }:
        import nixpkgs {
          system = system;
          config.allowUnfree = true;
          overlays = [ neovim-nightly-overlay.overlays.default ];
        };
    in
    {
      homeConfigurations = {
        # macOS (for private/work)
        darwin = home-manager.lib.homeManagerConfiguration {
          modules = [ ./.config/nix/hosts/darwin.nix ];
          pkgs = defaltPkgs {
            system = "aarch64-darwin";
          };
        };
      };
    };
}
