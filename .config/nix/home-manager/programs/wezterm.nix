{...}@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.file = {
    ".config/wezterm".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/wezterm";
  };
}
