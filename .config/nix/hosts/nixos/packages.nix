{ pkgs, neovim-src, ... }:
let
  neovim = pkgs.neovim.overrideAttrs
    (old: {
      version = "latest";
      src = neovim-src;
    });
in
with pkgs;
[
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
  typescript-language-server
  vim-language-server
  vscode-langservers-extracted
  vue-language-server
  yaml-language-server

  kubectl
  terraform
  act
  awscli2
  google-cloud-sdk
]
