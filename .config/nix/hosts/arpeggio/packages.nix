{ pkgs, ... }:
with pkgs; [
  nextdns

  vim
  neovim
  # emacs
  cachix
  lorri
  tree-sitter

  _1password-cli
  cachix
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
  lemonade
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
  pnpm
  python3
  uv
  ruff
  rustc
  typescript
  nodePackages.prettier

  llm-agents.ccusage
  llm-agents.ccusage-codex
  llm-agents.copilot-language-server

  astro-language-server
  lua-language-server
  bash-language-server
  dockerfile-language-server
  gopls
  fish-lsp
  lemminx
  vue-language-server
  nixd
  nixpkgs-fmt
  protols
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

  pandoc
  postgresql
  mariadb
  sqlite
  kubectl
  kustomize
  terraform
  nur.repos.peacock0803sz.tfcmt
  nur.repos.peacock0803sz.gwq
  tflint
  tflint-plugins.tflint-ruleset-google
  act
  pinact
  awscli2
  (google-cloud-sdk.withExtraComponents [
    google-cloud-sdk.components.alpha
    google-cloud-sdk.components.beta
    google-cloud-sdk.components.cloud-datastore-emulator
    google-cloud-sdk.components.cloud-firestore-emulator
    # google-cloud-sdk.components.cloud-spanner-emulator
    google-cloud-sdk.components.cloud-run-proxy
    google-cloud-sdk.components.cloud-sql-proxy
    google-cloud-sdk.components.gke-gcloud-auth-plugin
    google-cloud-sdk.components.log-streaming
    google-cloud-sdk.components.pubsub-emulator
  ])
  # firebase-tools
  yt-dlp
  ffmpeg
  imagemagick
]
