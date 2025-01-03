{ pkgs, vim-src, ... }:
let
  vim = pkgs.vim.overrideAttrs
    (old: {
      version = "latest";
      src = vim-src;
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
in
with pkgs;
[
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
  vim-language-server
  vscode-langservers-extracted
  vue-language-server
  yaml-language-server

  pandoc
  texliveFull
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
