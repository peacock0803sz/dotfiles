{ pkgs, specialArgs, ... }: {
  imports = [
    ./clients.nix
  ];

  home.stateVersion = "24.05";
  home.packages = import ./packages.nix { inherit pkgs specialArgs; };
}
