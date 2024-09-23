{ system, nixpkgs, neovim-nightly-overlay, ... }:
let
  pkgs = import nixpkgs {
    inherit system;
    overlays = [ neovim-nightly-overlay ];
  };
in
{
  home.stateVersion = "24.05";
  home.packages = import ./packages.nix { inherit pkgs; };
}
