{ config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
in
{
  programs.worktrunk = {
    enable = true;
    enableFishIntegration = true;
    claudeCodeIntegration = {
      enable = true;
      statusLine = false;
      configurationSkill = false;
      activityTrackingHooks = false;
    };
  };

  home.file.".config/worktrunk".source =
    mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/worktrunk";
}
