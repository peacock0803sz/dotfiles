{ pkgs, ... }:
with pkgs; [
  neovim
  tree-sitter

  _1password-cli
  bat
  cachix
  eza
  delta
  direnv
  fd
  fish
  fishPlugins.bass
  fishPlugins.tide
  fzf
  gibo
  git
  gojq
  gh
  ghq
  graphviz
  jq
  lnav
  ripgrep
  tmux
  tmuxPlugins.catppuccin
  tmuxPlugins.tmux-fzf
  wget
  vhs

  bun
  deno
  cargo
  go
  nodejs
  typescript

  bash-language-server
  dockerfile-language-server
  gopls
  fish-lsp
  lua-language-server
  nixd
  nixpkgs-fmt
  pyright
  stylua
  sqls
  tombi
  tailwindcss-language-server
  typescript-language-server
  terraform-ls
  tinymist
  vtsls
  vim-language-server
  vscode-langservers-extracted
  yaml-language-server

  ffmpeg
  imagemagick
  yt-dlp
  pandoc
  postgresql
  mariadb

  awscli2
  google-cloud-sdk

  _1password-gui
  chromium
  discord
  firefox
  google-chrome
  obs-studio
  slack
  vivaldi
  vivaldi-ffmpeg-codecs
]
