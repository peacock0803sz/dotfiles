{ pkgs, ... }: {
  imports = [
    ./small.nix

    ../programs/aibo.nix
    ../programs/claude-code.nix
    ../programs/gemini.nix
    ../programs/neovim.nix
  ];

  home.packages = with pkgs; [
    devenv
    nur.repos.peacock0803sz.gwq

    cargo
    go
    nodejs
    ruff
    typescript

    llm-agents.spec-kit

    astro-language-server
    bash-language-server
    dockerfile-language-server
    gopls
    fish-lsp
    lua-language-server
    nixd
    nixpkgs-fmt
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
    vue-language-server
    yaml-language-server

    pandoc
    vhs

    pinact
    cloudflared

    postgresql
    mariadb
    sqlite
  ];
}
