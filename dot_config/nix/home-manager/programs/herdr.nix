{ pkgs, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
in
{
  # herdr-core (hc) is not packaged yet; Herdr app installs it into ~/.local/bin
  home.packages = if pkgs.stdenv.hostPlatform.isDarwin then [ pkgs.brewCasks.herdr-app ] else [ ];

  home.file = {
    ".config/herdr-app/keys.json".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/herdr-app/keys.json";
    ".config/herdr-app/settings.json".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/herdr-app/settings.json";
  };
}
