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
