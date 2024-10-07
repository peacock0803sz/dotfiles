{ config, ... }: {
  home.file = {
    # ".config/fish/config.fish".source = lib.file.mkOutOfStoreSymlink ../../fish/config.fish;
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink ../../wezterm;
  };

  programs = {
    fish = {
      enable = true;
    };
    direnv = {
      enable = true;
      # enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
