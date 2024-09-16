{ ... }: {
  imports = [ ../packages.nix ];
  home = rec {
    username = "peacock";
    homeDirectory = "/Users/${username}";
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
