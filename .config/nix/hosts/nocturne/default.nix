{ inputs }:
let
  inherit (inputs) nix-darwin home-manager nixpkgs nix-monitored;

  system = "aarch64-darwin";
  username = "peacock";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-overlay.overlays.default
    ];
  };

  # {{{ Homebrew casks
  casks = [
    "adobe-creative-cloud"
    "alacritty"
    "bartender"
    "contexts"
    "coteditor"
    "cleanshot"
    "deskpad"
    "discord"
    "elgato-stream-deck"
    "fantastical"
    "firefox"
    "font-udev-gothic-nf"
    "ghostty"
    "google-chrome"
    "google-chrome@beta"
    "google-drive"
    "istat-menus"
    "jetbrains-toolbox"
    "karabiner-elements"
    "keycastr"
    "lasso"
    "linear-linear"
    "macskk"
    "orbstack"
    "obs"
    "raycast"
    "slack"
    "tailscale"
    "utm"
    "zoom"
    "vivaldi"
    "wezterm"
  ];
  # }}}
in
nix-darwin.lib.darwinSystem {
  modules = [
    home-manager.darwinModules.home-manager
    (import ../../nix-darwin { inherit system username pkgs casks nix-monitored; })
    {
      home-manager.backupFileExtension = "bk.nix";
      home-manager.users.${username} = {
        imports = [
          ../../home-manager/base.nix
          ../../home-manager/headed.nix
          ../../home-manager/darwin.nix
        ];

        home.packages = import ./packages.nix { inherit pkgs; };
      };
    }
  ];
}
