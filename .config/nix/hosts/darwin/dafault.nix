# { ... }: {
#   imports = [ ../packages.nix ];
#   home = rec {
#     username = "peacock";
#     homeDirectory = "/Users/${username}";
#     stateVersion = "24.05";
#   };
#   programs.home-manager.enable = true;
# }
{ nixpkgs, nix-darwin, home-manager, neovim-nightly-overlay }:
let
  system = "aarch64-darwin";
  username = "peacock";

  pkgs = import nixpkgs {
    system = system;
    config.allowUnfree = true;
    overlays = [ neovim-nightly-overlay.overlays.default ];
  };
in
{
  toccata = nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit username; };

    modules = [
      home-manager.darwinModules.home-manager
      {
        home-manager.useUserPackages = true;
        home-maanger.users.${username} = import ../../packages.nix {
          inherit pkgs;
        };
      }
    ];
  };
}
