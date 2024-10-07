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
        home-manager.users.${username} = {
          imports = [
            ../home-manager/defaults.nix
            ../home-manager/headed.nix
          ];

          home.stateVersion = specialArgs.homeManagerStateVersion;
          home.packages =
            import ../home-manager/packages.nix { inherit pkgs specialArgs; }
            ++ [ pkgs._1password ];
        };
      }
    ];
  };
}
