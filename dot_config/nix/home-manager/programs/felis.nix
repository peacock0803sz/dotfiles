{ pkgs, inputs, ... }:
{
  # config.toml はホストごとに hosts/*/home.nix で ~/Library/Application Support/felis/ へ symlink する
  home.packages = [ inputs.felis.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
