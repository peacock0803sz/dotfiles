{ pkgs-staging, ... }: {
  home.packages = with pkgs-staging; [
    direnv
  ];

  programs = {
    direnv = {
      nix-direnv.enable = true;
    };
  };
}
