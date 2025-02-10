{ pkgs, ... }:
with pkgs; [
  vim
  neovim
  # emacs-git

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
  tinymist
  typescript-language-server
  # vim-language-server
  vscode-langservers-extracted
  vue-language-server
  yaml-language-server

  pandoc
  # texliveFull
  postgresql
  mariadb
  sqlite
  kubectl
  terraform
  act
  awscli2
  google-cloud-sdk
  ffmpeg
  imagemagick
]
