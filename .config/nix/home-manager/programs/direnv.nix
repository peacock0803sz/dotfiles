{ ... }@inputs: {
  home.packages = with inputs.pkgs; [
    direnv
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
