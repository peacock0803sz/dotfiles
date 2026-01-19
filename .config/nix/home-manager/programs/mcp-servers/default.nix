{ pkgs, mcp-servers-nix, enableCodex, ... }:
(mcp-servers-nix.lib.evalModule pkgs {
  programs = import ./programs.nix { inherit pkgs enableCodex; };
}).config.settings.servers
