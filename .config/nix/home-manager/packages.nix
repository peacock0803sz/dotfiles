{ pkgs, specialArgs }:
let
  vim = pkgs.vim.overrideAttrs
    (old: {
      version = "latest";
      src = specialArgs.vim-src;
      buildInputs = old.buildInputs ++ (with pkgs; [ gettext lua libiconv ]);
      configureFlags = old.configureFlags ++
        [
          "--enable-terminal"
          "--with-compiledby=Peaocck (Yoichi Takai)"
          "--enable-luainterp"
          "--with-lua-prefix=${pkgs.lua}"
          "--enable-fail-if-missing"
        ];
    });
  neovim = pkgs.neovim.overrideAttrs
    (old: {
      version = "latest";
      src = specialArgs.neovim-src;
    });
in
with pkgs; [
  vim
  neovim
  emacs

  direnv
  eza
  delta
  fastfetch
  fd
  ffmpeg
  fish
  fishPlugins.bass
  fishPlugins.tide
  fzf
  gibo
  gojq
  gh
  gh-copilot
  ghq
  helix
  jq
  openjdk
  pandoc
  texliveFull
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
  nodejs
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
  lemminx
  nil
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
