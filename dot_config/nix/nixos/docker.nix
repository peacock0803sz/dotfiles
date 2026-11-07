# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ ... }: {
  virtualisation.docker.enable = true;

  # 掃除がないと、タグが動いて不要になったイメージが溜まり続ける
  # (enigma では Renovate の毎時 pull だけで 200GB を超えた)
  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "weekly";
    flags = [ "--filter" "until=168h" ];
  };
}
