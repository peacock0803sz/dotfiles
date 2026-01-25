{ ... }@inputs: {
  home.packages = with inputs.pkgs; [
    fish
    fishPlugins.bass
    fishPlugins.tide
  ];

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''source $HOME/dotfiles/.config/fish/config.fish'';
    };
  };
}
