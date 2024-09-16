{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, ... }:
  let
    configuration = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
          _1password
          direnv
          nix-direnv
          eza
          delta
          fd
          ffmpeg
          fish
          fzf
          gibo
          gojq
          gh
          ghq
          helix
          jq
          openjdk
          imagemagick
          nodePackages.prettier
          ripgrep
          tmux
          wget

          # Language Runtime
          bun
          cargo
          deno
          go
          nodejs_20
          python3
          uv
          rustc
          terraform
          typescript

          # Database
          postgresql
          mysql84
          sqlite

          # Public Cloud
          act
          awscli2
          google-cloud-sdk

          # LSP/Formatter
          astro-language-server
          lua-language-server
          bash-language-server
          dockerfile-language-server-nodejs
          gopls
          nixd
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

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#toccata
    darwinConfigurations."toccata" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."toccata".pkgs;
  };
}
