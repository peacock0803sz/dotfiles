{ pkgs, ... }: {
  imports = [
    ../profile.nix

    ../programs/bat.nix
    ../programs/fish.nix
  ];

  profile.levels = [ "tiny" ];

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
    tea
    trash-cli
    wget

    bun
    deno
    uv
  ];
}
