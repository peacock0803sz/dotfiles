{ self, username, nixpkgs, nix-darwin, home-manager, specialArgs, ... }:
let
  system = "aarch64-darwin";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
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
        home-manager.users.${username} = import ../home-manager/darwin.nix {
          inherit pkgs specialArgs;
        };
      }
    ];
  };
}
