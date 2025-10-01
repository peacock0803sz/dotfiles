{ inputs }:
let
  inherit (inputs) nix-darwin home-manager nixpkgs nix-monitored;

  system = "aarch64-darwin";
  username = "yoichi.takai";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-overlay.overlays.default
      inputs.vim-overlay.overlays.default
    ];
  };

  npmPkgs = pkgs.callPackage ../../node2nix { inherit pkgs; };
  brewCasks = import ./brewCasks.nix;
in
nix-darwin.lib.darwinSystem {
  modules = [
    home-manager.darwinModules.home-manager
    (import ../../nix-darwin { inherit system username pkgs brewCasks nix-monitored; })
    {
      home-manager.backupFileExtension = "bk.nix";
      home-manager.users.${username} = {
        imports = [
          ../../home-manager/base.nix
          ../../home-manager/headed.nix
          ../../home-manager/darwin.nix
        ];

        home.packages = import ./packages.nix { inherit pkgs npmPkgs; };
      };
    }
  ];
}
