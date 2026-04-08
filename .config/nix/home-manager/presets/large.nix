{ pkgs, ... }: {
  imports = [
    ./small.nix

    ../programs/neovim.nix
    ../programs/tmux.nix
  ];

  home.packages = with pkgs; [
    devenv
    git-wt
    nur.repos.peacock0803sz.notizen

    cargo
    go
    nodejs
    ruff
    ty
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

    cloudflared
    octorus
    pinact

    postgresql
    mariadb
    sqlite
  ];
}
