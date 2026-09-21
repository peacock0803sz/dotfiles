{ inputs, ... }:
let
  inherit (inputs) nixos-hardware nixpkgs home-manager disko nix-monitored;
  username = "peacock";
  system = "aarch64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config = import ../../nixpkgs.nix;
  };
in
nixpkgs.lib.nixosSystem {
  system = system;
  specialArgs = inputs // {
    inherit system username;
    name = "overture";
    ip = "10.57.0.1";
    # Raspberry Pi 4 のオンボード NIC。predictable naming では end0 になる。
    # `ip -o link show` で実名を確認し、違えばここを直すこと (anyconnect.nix の NAT が参照する)
    lanInterface = "end0";
  };
  modules = [
    { nixpkgs.pkgs = pkgs; }
    disko.nixosModules.disko
    nix-monitored.nixosModules.default
    nixos-hardware.nixosModules.raspberry-pi-4
    ./disk.nix
    ./hardware.nix
    ../../nixos
    ../../nixos/anyconnect.nix
    ../../nixos/lemonade.nix
    ../../nixos/prometheus-exporters.nix

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { };
      home-manager.users."${username}" = {
        imports = [
          ../../home-manager
          ../../home-manager/platforms/nixos.nix
          ../../home-manager/presets/tiny.nix
        ];
      };
    }
  ];
}
