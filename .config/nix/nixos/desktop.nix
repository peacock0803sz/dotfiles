# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ modulesPath, system, pkgs, nix-monitored, ... }:

{
  environment.systemPackages = with pkgs; [
    ghostty
  ];

  programs = {
    niri.enable = true;
    sway.enable = true;
    waybar.enable = true;
  };
  services = { };

  virtualisation.docker.enable = true;
}
