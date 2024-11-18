{ config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    "/Library/LaunchAgents/com.notizen.syncd".source = mkOutOfStoreSymlink ~/dotfiles/.config/LaunchAgents/com.notizen.syncd;
  };
}
