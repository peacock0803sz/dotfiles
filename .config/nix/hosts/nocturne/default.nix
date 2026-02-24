{ inputs }:
let
  inherit (inputs) nixpkgs;

  system = "aarch64-darwin";
  username = "peacock";
  hostName = "nocturne";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.brew-nix.overlays.default
      inputs.neovim-overlay.overlays.default
      inputs.nur.overlays.default
      inputs.llm-agents.overlays.default
    ];
  };
in
inputs.nix-darwin.lib.darwinSystem {
  specialArgs = { inherit system username hostName pkgs inputs; };
  modules = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
    ../../nix-darwin
    ../../nix-darwin/lemonade.nix
    {
      home-manager.backupFileExtension = "bk.nix";
      home-manager.useGlobalPkgs = true;
      home-manager.extraSpecialArgs = { inherit hostName system inputs; };
      home-manager.users.${username} = {
        imports = [
          ./home.nix
          ../../home-manager
          ../../home-manager/platforms/darwin.nix
          ../../home-manager/presets/huge.nix
          inputs.agent-skills.homeManagerModules.upstream
          inputs.agent-skills.homeManagerModules.config
        ];
      };
    }
  ];
}
