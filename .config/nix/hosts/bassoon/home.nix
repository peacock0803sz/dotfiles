{ pkgs, config, ... }:
{
  programs.fish.shellInit = "export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}";
}
