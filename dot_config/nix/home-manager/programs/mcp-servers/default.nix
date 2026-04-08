{ pkgs, mcp-servers-nix, ... }:
(mcp-servers-nix.lib.evalModule pkgs {
  programs = import ./programs.nix { inherit pkgs; };
}).config.settings.servers
