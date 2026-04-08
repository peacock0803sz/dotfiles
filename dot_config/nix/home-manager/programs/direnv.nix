{ pkgs, ... }: {
  home.packages = with pkgs; [
    direnv
  ];

  programs = {
    direnv = {
      nix-direnv.enable = true;
    };
  };
}
