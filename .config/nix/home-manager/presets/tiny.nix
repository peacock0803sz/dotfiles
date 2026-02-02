{ pkgs, ... }: {
  imports = [
    ../programs/bat.nix
    ../programs/fish.nix
  ];

  home.packages = with pkgs; [
    cachix
    comma
    eza
    delta
    fd
    fzf
    gh
    ghq
    gojq
    jq
    lemonade
    ripgrep
    wget

    bun
    deno
    uv
  ];
}
