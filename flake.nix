{
  description = "Peacock's Nix Configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.system.follows = "systems";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, neovim-nightly-overlay, flake-utils, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ neovim-nightly-overlay.overlays.default ];
      };
      packages = with pkgs; [
        direnv
        eza
        fd
        ffmpeg
        fish
        fzf
        gojq
        gh
        ghq
        jq
        openjdk
        imagemagick
        ripgrep

        # Language Runtime
        cargo
        deno
        go
        nodejs_20
        python3
        rustc
        terraform

        # Database
        postgresql
        mysql84
        sqlite

        # Public Cloud
        awscli2
        google-cloud-sdk

        # LSP/Formatter
        luajitPackages.lua-lsp
        nixd
        pyright
        ruff-lsp
        stylua
        terraform-ls
      ];
    in
    flake-utils.lib.eachDefaultSystem (system: {
      formatter = pkgs.nixpkgs-fmt;
      packages.default = pkgs.buildEnv {
        name = "default-packages";
        paths = [ neovim-nightly-overlay.packages.${system}.default ] ++ packages;
      };
    });
}
