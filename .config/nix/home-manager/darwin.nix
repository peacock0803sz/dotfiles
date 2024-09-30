{ pkgs, specialArgs }: {
  home.stateVersion = "24.05";
  home.packages = import ./packages.nix { inherit pkgs specialArgs; };
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''source $HOME/dotfiles/.config/fish/config.fish'';
    };
    direnv = {
      enable = true;
      # enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
