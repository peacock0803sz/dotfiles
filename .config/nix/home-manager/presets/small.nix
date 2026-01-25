{ ... }@inputs: {
  imports = [
    ./tiny.nix

    ../programs/direnv.nix
    ../programs/lnav.nix
  ];

  home.packages = with inputs.pkgs; [
    yt-dlp
    ffmpeg
    imagemagick
  ];
}
