{ pkgs, npmPkgs, ... }:
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
  lemonade
  ripgrep
  tmux
  tmuxPlugins.catppuccin
  wget

  bun
  deno
  nodejs
  pnpm
  uv
  ruff
  go
  typescript
  nodePackages.prettier
  # npmPkgs."@github/copilot-language-server"
  # npmPkgs."@google/gemini-cli"
  npmPkgs."@anthropic-ai/claude-code"
  npmPkgs."editprompt"

  astro-language-server
  bash-language-server
  dockerfile-language-server
  gopls
  lemminx
  lua-language-server
  nixd
  nixpkgs-fmt
  npmPkgs."@vue/language-server"
  pyright
  stylua
  yaml-language-server
  taplo
  tailwindcss-language-server
  terraform-ls
  tree-sitter
  vtsls
  vim-language-server
  vscode-langservers-extracted
  typescript-language-server

  pandoc
  yt-dlp
  # texliveFull
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
