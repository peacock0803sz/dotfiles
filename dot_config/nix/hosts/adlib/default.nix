# arpeggio 上の tart VM。Muse や Claude Duet などのエージェントを手元の環境から隔離して動かす
{ inputs }:
let
  inherit (inputs) nixpkgs;

  system = "aarch64-darwin";
  # cirruslabs の tart イメージの既定ユーザー
  username = "admin";
  hostName = "adlib";

  pkgs = import nixpkgs {
    inherit system;
    config = import ../../nixpkgs.nix;
    overlays = [
      inputs.brew-nix.overlays.default
    ];
  };
in
inputs.nix-darwin.lib.darwinSystem {
  specialArgs = { inherit system username hostName pkgs inputs; };
  modules = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
    ../../nix-darwin
    ../../nix-darwin/lemonade.nix

    {
      # エージェントは向こうから動き出すので、VM 内ではスリープも画面ロックもさせない
      power.sleep = { computer = "never"; display = "never"; };

      homebrew.casks = [
        "font-udev-gothic-nf"
        "font-jetbrains-mono-nerd-font"
        "google-chrome"
        "karabiner-elements"
      ];
    }

    {
      home-manager.backupFileExtension = "bk.nix";
      home-manager.useGlobalPkgs = true;
      home-manager.extraSpecialArgs = { inherit hostName system inputs; };
      # 認証情報や業務設定を持ち込まないよう、platforms/darwin.nix や work.nix は入れない
      home-manager.users.${username} = { config, pkgs, ... }: {
        imports = [
          ../../home-manager
          ../../home-manager/presets/tiny.nix
          ../../home-manager/programs/tmux.nix
        ];

        # programs/ghostty.nix は peafowl-colors (ghq 配下) へのリンクも張るので使わない
        home.packages = [ pkgs.brewCasks.ghostty ];
        home.file.".config/ghostty/config".source = config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/dotfiles/dot_config/ghostty/adlib.config";
      };
    }
  ];
}
