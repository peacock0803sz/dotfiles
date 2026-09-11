{ pkgs, ... }: {
  imports = [
    ../programs/bat.nix
    ../programs/fish.nix
  ];

  home.packages = with pkgs; [
    cachix
    comma
    nix-sweep

    eza
    delta
    dust
    fd
    fzf
    gh
    ghq
    git-credential-oauth
    gomi
    gojq
    jq
    lemonade
    ripgrep
    trash-cli
    wget

    bun
    deno
    uv
  ];
}
