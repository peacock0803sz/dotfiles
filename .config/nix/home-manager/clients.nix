{ config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".gitconfig".source = mkOutOfStoreSymlink ~/dotfiles/.gitconfig;
    ".config/alacritty".source = mkOutOfStoreSymlink ~/dotfiles/.config/alacritty;
    ".config/bat".source = mkOutOfStoreSymlink ~/dotfiles/.config/bat;
    ".config/nvim".source = mkOutOfStoreSymlink ~/dotfiles/.config/nvim;
    ".config/obsidian.nvim".source = mkOutOfStoreSymlink ~/.config/obsidian.nvim;
    ".config/wezterm".source = mkOutOfStoreSymlink ~/dotfiles/.config/wezterm;
  };
}
