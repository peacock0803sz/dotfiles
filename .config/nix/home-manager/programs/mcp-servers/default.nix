{ pkgs, mcp-servers-nix, enableCodex, ... }:
(mcp-servers-nix.lib.evalModule pkgs {
  programs = import ./programs.nix { inherit enableCodex; };
}).config.settings.servers
