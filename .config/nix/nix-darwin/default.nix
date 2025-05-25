{ system, username, pkgs, casks, nix-monitored, ... }: {
  nix = {
    enable = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    package = nix-monitored.packages.${pkgs.system}.default;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "root" "${username}" ];
    };
  };

  nixpkgs.hostPlatform = system;
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
    casks = casks;
  };

  system = {
    stateVersion = 5;

    primaryUser = username;
    activationScripts.extraActivation.text = ''
      chsh -s /run/current-system/sw/bin/fish
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
