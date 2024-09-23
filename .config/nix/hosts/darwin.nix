{ self, nixpkgs, nix-darwin, home-manager, neovim-nightly-overlay, ... }:
let
  system = "aarch64-darwin";
  username = "peacock";
  configuration = { ... }: {
    users.users.${username}.home = "/Users/${username}";
  };
in
{
  darwin = nix-darwin.lib.darwinSystem {
    inherit self system;

    modules = [
      configuration
      home-manager.darwinModules.home-manager
      {
        home-manager.useUserPackages = true;
        home-manager.users.${username} = import ../../home-manager/darwin.nix {
          inherit system nixpkgs neovim-nightly-overlay;
        };
      }
    ];
  };
}
