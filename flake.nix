{
  description = "Peacock's Nix Configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.system.follows = "systems";
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
        # pkgs = import nixpkgs {
        #   inherit system;
        #   config.allowUnfree = true;
        #   overlays = [ neovim-nightly-overlay.overlays.default ];
        # };
        # vim = pkgs.vim.overrideAttrs (old: {
        #   version = "latest";
        #   src = vim-src;
        #   buildInputs = old.buildInputs ++ (with pkgs; [ gettext lua libiconv ]);
        #   configureFlags = old.configureFlags ++
        #     [
        #       "--enable-terminal"
        #       "--with-compiledby=Peaocck (Yoichi Takai)"
        #       "--enable-luainterp"
        #       "--with-lua-prefix=${pkgs.lua}"
        #       "--enable-fail-if-missing"
        #     ];
        # });
        # neovim = neovim-nightly-overlay.packages.${system}.default;
      in
      {
        # formatter = pkgs.nixpkgs-fmt;
        homeConfigurations = {
          toccata = home-manager.lib.homeManagerConfiguration {
            modules = [./.config/nix/hosts/toccata.nix];
            pkgs = import nixpkgs {
              system = "aarch64-darwin";
              config.allowUnfree = true;
              # overlays = [ neovim-nightly-overlay.overlays.default ];
            };
          };
        };
      };
}
