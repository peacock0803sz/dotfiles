{ ...}: {
  imports = [../packages.nix];
  home = rec {
    username = "peacock";
    homeDirectory = "/Users/${username}";
    # packages = import ../packages.nix { inherit pkgs; };
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
