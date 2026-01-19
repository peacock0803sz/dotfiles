{ pkgs, ... }: {
  home.file = {
    ".config/ghostty/themes".source = (pkgs.fetchgit {
      url = "https://github.com/catppuccin/ghostty";
      sparseCheckout = [ "themes" ];
      hash = "sha256-6w8+zIrXaOQZLF71VIiU55xMsrzupnzkGDUmAefpMqg=";
    }).outPath + "/themes";
  };
}
