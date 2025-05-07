{ inputs }:
let
  inherit (inputs) nix-darwin home-manager nixpkgs;

  system = "aarch64-darwin";
  username = "peacock";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.neovim-overlay.overlays.default
      inputs.vim-overlay.overlays.default
    ];
  };

  # {{{ Homebrew casks
  casks = [
    "adobe-creative-cloud"
    "alacritty"
    "bartender"
    "contexts"
    "cleanshot"
    "deskpad"
    "discord"
    "elgato-stream-deck"
    "fantastical"
    "figma"
    "firefox"
    "font-udev-gothic-nf"
    "ghostty"
    "google-chrome"
    "google-chrome@beta"
    "google-chrome@dev"
    "google-drive"
    "istat-menus"
    "jetbrains-toolbox"
    "karabiner-elements"
    "keycastr"
    "lasso"
    "linear-linear"
    "marta"
    "macskk"
    "notion"
    "obsidian"
    "orbstack"
    "raycast"
    "slack"
    "tailscale"
    "utm"
    "zoom"
    "visual-studio-code"
    "vivaldi"
    "wezterm"
    "windows-app"
  ];
  # }}}
in
nix-darwin.lib.darwinSystem {
  modules = [
    home-manager.darwinModules.home-manager
    (import ../../nix-darwin { inherit system username pkgs casks; })
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
