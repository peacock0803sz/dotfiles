{ enableCodex, ... }: {
  codex.enable = enableCodex;
  serena = {
    enable = true;
    args = [ "--context" "ide-assistant" "--enable-web-dashboard" "False" ];
  };
  context7.enable = true;
  playwright.enable = true;
  github.enable = true;
  terraform.enable = true;
  nixos.enable = true;
  time = {
    enable = true;
    args = [ "--local-timezone=Asia/Tokyo" ];
  };
}
