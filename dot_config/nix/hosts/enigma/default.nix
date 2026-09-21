{ inputs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-staging;
  username = "peacock";
  system = "x86_64-linux";
  hostName = "enigma";
  pkgs = import nixpkgs {
    inherit system;
    config = (import ../../nixpkgs.nix) // { cudaSupport = true; };
    overlays = [
      inputs.vim-overlay.overlays.default
      inputs.neovim-overlay.overlays.default
      inputs.nur.overlays.default
    ];
  };
  pkgs-staging = import nixpkgs-staging {
    inherit system;
    config.allowUnfree = true;
  };
in
nixpkgs.lib.nixosSystem {
  system = system;
  specialArgs = inputs // { inherit system username; };
  modules = [
    { nixpkgs.pkgs = pkgs; }

    {
      # grafana.p3ac0ck.net は bassoon.tail2121a.ts.net への CNAME だが、ts.net の
      # ノード名は公開 DNS に存在せず、MagicDNS も管轄外ドメインの CNAME を自ゾーンへ
      # 追い直さないため、どちらのリゾルバでも NXDOMAIN になる。LAN ルータ経由でしか
      # 引けない状態だったので、bassoon の tailnet IP を直接当てる。
      # この IP は bassoon が登録され続ける限り不変だが、disko で消して入れ直すと
      # ノードキーを失って再採番される。bassoon 再インストール時はここも直すこと
      networking.hosts."100.98.92.79" = [ "grafana.p3ac0ck.net" ];
    }

    inputs.disko.nixosModules.disko
    inputs.nix-index-database.nixosModules.nix-index
    inputs.nix-monitored.nixosModules.default
    ../../nixos/default.nix
    ../../nixos/docker.nix
    ../../nixos/gitea-actions-runner.nix
    ../../nixos/neovim.nix
    ../../nixos/lemonade.nix
    ../../nixos/oksskolten.nix
    ../../nixos/prometheus-exporters.nix
    ../../nixos/prometheus-agents-usage.nix

    ./hardware.nix
    ./disk.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit hostName inputs pkgs-staging; };
      home-manager.users."${username}" = {
        imports = [
          ./home.nix

          ../../home-manager
          ../../home-manager/platforms/nixos.nix
          ../../home-manager/presets/large.nix
          inputs.agent-skills.homeManagerModules.upstream
          inputs.agent-skills.homeManagerModules.config
        ];
      };
    }
  ];
}
