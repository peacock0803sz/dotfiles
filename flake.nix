{
  description = "Peacock's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, neovim-nightly-overlay, ... }:
    let
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
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
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
      packages.aarch64-darwin.default = pkgs.buildEnv {
        name = "default-packages";
        paths = packages;
      };
    };
}
