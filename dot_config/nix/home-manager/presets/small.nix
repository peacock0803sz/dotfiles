{ pkgs, ... }: {
  imports = [
    ./tiny.nix

    ../programs/direnv.nix
    ../programs/lnav.nix
  ];

  home.packages = with pkgs; [
    yt-dlp
    ffmpeg
    imagemagick
  ];
}
