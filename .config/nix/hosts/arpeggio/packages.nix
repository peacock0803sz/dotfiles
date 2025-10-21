{ pkgs, npmPkgs, ... }:
with pkgs; [
  vim
  neovim
  # emacs

  _1password-cli
  devenv
  direnv
  bat
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
  graphviz
  jq
  iproute2mac
  lnav
  ripgrep
  tmux
  tmuxPlugins.catppuccin
  tmuxPlugins.tmux-fzf
  wget

  bun
  deno
  go
  nodejs
  pnpm
  uv
  ruff
  typescript
  nodePackages.prettier
  npmPkgs."@openai/codex"
  npmPkgs."@ccusage/codex"
  npmPkgs."editprompt"
  npmPkgs."gemistat"
  npmPkgs."@github/copilot-language-server"
  npmPkgs."@google/gemini-cli"

  astro-language-server
  lua-language-server
  bash-language-server
  dockerfile-language-server
  gopls
  lemminx
  nixd
  nixpkgs-fmt
  protols
  pyright
  stylua
  taplo
  tailwindcss-language-server
  terraform-ls
  tinymist
  vtsls
  vim-language-server
  vscode-langservers-extracted
  vue-language-server
  yaml-language-server

  pandoc
  postgresql
  mariadb
  sqlite
  kubectl
  terraform
  tflint
  tflint-plugins.tflint-ruleset-google
  act
  # awscli2
  google-cloud-sdk
  ffmpeg
  imagemagick
]
