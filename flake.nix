{
  description = "Peacock's Nix Configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.system.follows = "systems";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, neovim-nightly-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ neovim-nightly-overlay.overlays.default ];
        };
        packages = with pkgs; [
          _1password
          direnv
          nix-direnv
          eza
          fd
          ffmpeg
          fish
          fzf
          gojq
          gh
          ghq
          helix
          jq
          openjdk
          imagemagick
          nodePackages.prettier
          ripgrep

          # Language Runtime
          bun
          cargo
          deno
          go
          nodejs_20
          python3
          rustc
          terraform
          typescript

          # Database
          postgresql
          mysql84
          sqlite

          # Public Cloud
          awscli2
          google-cloud-sdk

          # LSP/Formatter
          lua-language-server
          dockerfile-language-server-nodejs
          nixd
          nodePackages.vls
          pyright
          ruff-lsp
          stylua
          taplo
          tailwindcss-language-server
          terraform-ls
          typescript-language-server
          vim-language-server
          vscode-langservers-extracted
          vue-language-server
          yaml-language-server
        ];
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        packages.default = pkgs.buildEnv {
          name = "default-packages";
          paths = [ neovim-nightly-overlay.packages.${system}.default ] ++ packages;
        };
      });
}
