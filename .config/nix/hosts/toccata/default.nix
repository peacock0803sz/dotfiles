{ inputs }:
let
  inherit (inputs) nix-darwin home-manager nixpkgs;

  system = "aarch64-darwin";
  username = "peacock";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      }))
    ];
  };
in
nix-darwin.lib.darwinSystem {
  modules = [
    home-manager.darwinModules.home-manager
    (import ../../nix-darwin { inherit system username pkgs; })
    {
      home-manager.users.${username} = {
        imports = [
          ../../home-manager/base.nix
          ../../home-manager/headed.nix
          ./home-manager.nix
        ];

        home.packages = import ../../packages {
          inherit pkgs;
          inherit (inputs) vim-src neovim-src;
          # kinds = [ "common" "vim" "neovim" "emacs" "editorTools" "pandoc" "databases" "infra" "media" ];
        };
      };
    }
  ];
}
