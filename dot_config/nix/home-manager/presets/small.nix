{ pkgs, ... }: {
  imports = [
    ./tiny.nix

    ../programs/direnv.nix
    ../programs/lnav.nix
    ../programs/neovim.nix
  ];

  profile.levels = [ "small" ];

  home.packages = with pkgs; [
    yt-dlp
    ffmpeg
    imagemagick
    librsvg
  ];
}
