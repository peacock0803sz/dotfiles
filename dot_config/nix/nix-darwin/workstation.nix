{ ... }: {
  homebrew = {
    taps = [
      { name = "arto-app/tap"; trusted = true; }
    ];
    casks = [
      "1password"
      "adobe-creative-cloud"
      "arto-app/tap/arto"
      # "chatgpt"
      # "claude"
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
}
