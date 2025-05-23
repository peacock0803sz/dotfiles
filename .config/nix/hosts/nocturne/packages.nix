{ pkgs, ... }:
with pkgs; [
  vim
  neovim

  _1password-cli
  devenv
  direnv
  eza
  delta
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
  jq
  ripgrep
  tmux
  tmuxPlugins.catppuccin
  wget

  bun
  deno
  nodejs
  pnpm
  uv
  typescript
  gh-copilot
  nodePackages.prettier

  astro-language-server
  lua-language-server
  bash-language-server
  dockerfile-language-server-nodejs
  gopls
  lemminx
  nixd
  nixpkgs-fmt
  pyright
  stylua
  taplo
  tailwindcss-language-server
  terraform-ls
  typescript-language-server
  vim-language-server
  vscode-langservers-extracted
  vue-language-server
  yaml-language-server

  pandoc
  texliveFull
  postgresql
  sqlite
  kubectl
  terraform
  act
  awscli2
  google-cloud-sdk
  ffmpeg
  imagemagick
]
