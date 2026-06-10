{ pkgs, ... }: {
  serena = {
    enable = true;
    args = [ "--context" "ide-assistant" "--enable-web-dashboard" "False" ];
  };
  context7.enable = true;
  playwright = {
    enable = true;
    # macOS (darwin) ではシステムの Chrome を使用、NixOS では nixpkgs の chromium を使用
    executable =
      if pkgs.stdenv.isDarwin
      then "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
      else "${pkgs.chromium}/bin/chromium";
  };
  github = {
    enable = true;
    passwordCommand = "echo \"GITHUB_PERSONAL_ACCESS_TOKEN=$(gh auth token)\"";
  };
  terraform.enable = true;
  nixos = {
    enable = true;
    # mcp-nixos 2.4.3 の test_read_text_file は /nix/store の中身依存で darwin だと flaky。
    # nixpkgs master では無効化済みなので、nixpkgs 更新後にこの override は削除可
    package = pkgs.mcp-nixos.overridePythonAttrs (old: {
      disabledTests = (old.disabledTests or [ ]) ++ [ "test_read_text_file" ];
    });
  };
  time = {
    enable = true;
    args = [ "--local-timezone=Asia/Tokyo" ];
  };
}
