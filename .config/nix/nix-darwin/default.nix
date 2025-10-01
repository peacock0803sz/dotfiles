{ ... }@inputs: {
  nix = {
    enable = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    package = inputs.nix-monitored.packages.${inputs.pkgs.system}.default;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "root" "${inputs.username}" ];
    };
  };

  nixpkgs.hostPlatform = inputs.system;
  users.users.${inputs.username} = {
    home = "/Users/${inputs.username}";
    shell = inputs.pkgs.fish;
  };
  environment = {
    shells = [ inputs.pkgs.fish ];
  };
  programs.fish.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    casks = inputs.brewCasks;
  };

  system = {
    stateVersion = 5;

    primaryUser = inputs.username;
    activationScripts.extraActivation.text = ''
      chsh -s /Users/${inputs.username}/.nix-profile/bin/fish ${inputs.username}
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
      ${inputs.username} ALL=(ALL) NOPASSWD: ALL
    '';
    pam.services.sudo_local.touchIdAuth = true;
  };
}
