{ pkgs, ... }:
with pkgs; [
  # GUI Apps
  # wezterm
  # alacritty
  # raycast
  neovim

  _1password
  direnv
  eza
  delta
  fd
  ffmpeg
  fish
  fzf
  gibo
  gojq
  gh
  ghq
  helix
  jq
  openjdk
  imagemagick
  nodePackages.prettier
  ripgrep
  tmux
  wget
  kubectl

  # Language Runtime
  bun
  cargo
  deno
  go
  nodejs_20
  python3
  uv
  rustc
  terraform
  typescript

  # Database
  postgresql
  mysql84
  sqlite

  # Public Cloud
  act
  awscli2
  google-cloud-sdk

  # LSP/Formatter
  astro-language-server
  lua-language-server
  bash-language-server
  dockerfile-language-server-nodejs
  gopls
  nixd
  nixpkgs-fmt
  pyright
  ruff-lsp
  stylua
  taplo
  tailwindcss-language-server
  terraform-ls
  typescript-language-server
  vim-language-server
  vscode-langservers-extracted
  vue-language-server
  yaml-language-server
]
