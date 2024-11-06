{ self, username, nixpkgs, nix-darwin, home-manager, specialArgs, ... }:
let
  system = "aarch64-darwin";
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
{
  darwin = nix-darwin.lib.darwinSystem {
    modules = [
      home-manager.darwinModules.home-manager
      (import ../nix-darwin { inherit self system username nixpkgs pkgs; })
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = {
          imports = [
            ../home-manager/defaults.nix
            ../home-manager/headed.nix
            ../home-manager/darwin.nix
          ];

          home.stateVersion = specialArgs.homeManagerStateVersion;
          home.packages =
            import ../home-manager/packages.nix { inherit pkgs specialArgs; }
            ++ [ pkgs._1password-cli pkgs.tmux ];
        };
      }
    ];
  };
}
