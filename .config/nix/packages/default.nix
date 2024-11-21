{ pkgs, vim-src, neovim-src, ... }:
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
  neovim = pkgs.neovim.overrideAttrs
    (old: {
      version = "latest";
      src = neovim-src;
    });
  #   packages = with pkgs; {
  #     common = [
  #       devenv
  #       direnv
  #       eza
  #       delta
  #       fd
  #       fish
  #       fishPlugins.bass
  #       fishPlugins.tide
  #       fzf
  #       gibo
  #       gojq
  #       gh
  #       ghq
  #       jq
  #       ripgrep
  #       wget
  # 
  #       # Language Runtime
  #       bun
  #       deno
  #     ];
  #     vim =
  #       if vim-src != null then [
  #         vim.overrideAttrs
  #         (old: {
  #           version = "latest";
  #           src = vim-src;
  #           buildInputs = old.buildInputs ++ [ gettext lua libiconv ];
  #           configureFlags = old.configureFlags ++
  #             [
  #               "--enable-terminal"
  #               "--with-compiledby=Peaocck (Yoichi Takai)"
  #               "--enable-luainterp"
  #               "--with-lua-prefix=${pkgs.lua}"
  #               "--enable-fail-if-missing"
  #             ];
  #         })
  #       ] else [ ];
  #     neovim = [
  #       neovim.overrideAttrs
  #       (old: {
  #         version = "latest";
  #         src = neovim-src;
  #       })
  # 
  #       nodejs
  #       typescript
  #       gh-copilot
  #     ];
  #     emacs = [ emacs ];
  #     editorTools = [
  #       nodePackages.prettier
  # 
  #       astro-language-server
  #       lua-language-server
  #       bash-language-server
  #       dockerfile-language-server-nodejs
  #       gopls
  #       lemminx
  #       nil
  #       nixpkgs-fmt
  #       pyright
  #       stylua
  #       taplo
  #       tailwindcss-language-server
  #       terraform-ls
  #       typescript-language-server
  #       vim-language-server
  #       vscode-langservers-extracted
  #       vue-language-server
  #       yaml-language-server
  #     ];
  #     pandoc = [
  #       pandoc
  #       texliveFull
  #     ];
  #     databases = [
  #       postgresql
  #       mysql84
  #       sqlite
  #     ];
  #     infra = [
  #       kubectl
  #       terraform
  #       act # GitHub Actions
  #       awscli2
  #       google-cloud-sdk
  #     ];
  #     media = [
  #       ffmpeg
  #       imagemagick
  #     ];
  #   };
in
# config.lib.flatten (map (kind: packages.${kind}) kinds)
with pkgs;
[
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

  # Language Runtime
  bun
  deno
  vim
  neovim

  nodejs
  pnpm
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
  mysql84
  sqlite
  kubectl
  terraform
  act # GitHub Actions
  awscli2
  google-cloud-sdk
  ffmpeg
  imagemagick
]
