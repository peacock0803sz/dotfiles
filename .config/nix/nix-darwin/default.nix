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
      extra-substituters = [ "https://cache.numtide.com" ];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
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
