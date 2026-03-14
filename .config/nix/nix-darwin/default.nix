{ pkgs, system, username, hostName, inputs, ... }: {
  nix = {
    enable = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 1d";
    };
    optimise.automatic = true;
    package = inputs.nix-monitored.packages.${system}.default;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "root" "${username}" ];
      extra-substituters = [
        "https://cache.numtide.com"
        "https://cache.nixos.org"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "peacock0803sz.cachix.org-1:dfSrzcK5CS+mrpCCM4md1zP9YxLv+ddWGewTI0pdfsE="
      ];
    };
  };

  nixpkgs = {
    hostPlatform = system;
    config.allowUnfree = true;
  };
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.fish;
  };
  environment = {
    shells = [ pkgs.fish ];
  };
  programs.fish.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    casks = [
      "1password"
      "adobe-creative-cloud"
      "font-udev-gothic-nf"
      "font-jetbrains-mono-nerd-font"
      "google-chrome"
      "google-chrome@beta"
      "google-chrome@dev"
      "google-drive"
      "karabiner-elements"
      "tailscale-app"
      "vivaldi"
      "zoom"
    ];
  };
  launchd.labelPrefix = "net.p3ac0ck.nix";

  networking.hostName = hostName;
  system = {
    stateVersion = 5;

    primaryUser = username;
    activationScripts.extraActivation.text = ''
      chsh -s /Users/${username}/.nix-profile/bin/fish ${username}
    '';
    # + nixpkgs.lib.optionalString (
    #  nixpkgs.stdenv.isAarch64 ''softwareupdate --install-rosetta --agree-to-license''
    # );

    defaults = {
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      LaunchServices.LSQuarantine = false;
      NSGlobalDomain.AppleShowAllExtensions = true;
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "Nlsv";
        _FXShowPosixPathInTitle = true;
      };
      dock = {
        autohide = true;
        show-recents = false;
        launchanim = false;
        orientation = "right";
      };
      trackpad = {
        Clicking = true;
        Dragging = true;
      };
    };
  };

  security = {
    sudo.extraConfig = ''
      ${username} ALL=(ALL) NOPASSWD: ALL
    '';
    pam.services.sudo_local.touchIdAuth = true;
  };
}
