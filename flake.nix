{
  description = "Peacock's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-staging.url = "github:NixOS/nixpkgs/staging-next";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
    };
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };
    darwin-vz-nix.url = "github:takeokunn/darwin-vz-nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # vim-overlay = {
    #   url = "github:kawarimidoll/vim-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    agent-skills.url = "path:./dot_config/nix/home-manager/programs/agent-skills";
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    arto.url = "github:arto-app/Arto";
    vibra.url = "github:peacock0803sz/vibra";
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      flake = {
        darwinConfigurations = {
          nocturne = import ./dot_config/nix/hosts/nocturne { inherit inputs; };
          arpeggio = import ./dot_config/nix/hosts/arpeggio { inherit inputs; };
        };
        nixosConfigurations = {
          bassoon = import ./dot_config/nix/hosts/bassoon { inherit inputs; };
          overture = import ./dot_config/nix/hosts/overture { inherit inputs; };
          enigma = import ./dot_config/nix/hosts/enigma { inherit inputs; };
        };
      };
      perSystem = { ... }: { };
    };
}
