{ ... }@inputs:
let
  mkOutOfStoreSymlink = inputs.config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = inputs.config.home.homeDirectory;
in
{
  home.packages = with inputs.pkgs; [
    neovim
    tree-sitter
  ];
  home.file = {
    ".config/nvim".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/.config/nvim";
  };
}
