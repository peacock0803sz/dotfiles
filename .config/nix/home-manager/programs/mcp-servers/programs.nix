{ pkgs, enableCodex, ... }:
let
  # macOS (darwin) ではシステムの Chrome を使用、NixOS では nixpkgs の chromium を使用
  playwrightExecutable =
    if pkgs.stdenv.isDarwin
    then "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    else "${pkgs.chromium}/bin/chromium";
in
{
  codex.enable = enableCodex;
  serena = {
    enable = true;
    args = [ "--context" "ide-assistant" "--enable-web-dashboard" "False" ];
  };
  context7.enable = true;
  playwright = {
    enable = true;
    executable = playwrightExecutable;
  };
  github = {
    enable = true;
    passwordCommand = "echo \"GITHUB_PERSONAL_ACCESS_TOKEN=$(gh auth token)\"";
  };
  terraform.enable = true;
  nixos.enable = true;
  time = {
    enable = true;
    args = [ "--local-timezone=Asia/Tokyo" ];
  };
}
