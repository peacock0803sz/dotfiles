{ pkgs, lib, config, inputs, llm-agents, ... }:
let
  inherit (inputs) mcp-servers-nix;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  homeDirectory = config.home.homeDirectory;
  piMcpAdapter = "npm:pi-mcp-adapter@latest";

  # pi 本体は MCP 非対応で pi-mcp-adapter 拡張が Claude 形式 ({"mcpServers": ...}) を読むため、
  # claude-code.nix と同じサーバー定義からデフォルト flavor でそのまま生成できる
  mcpConfig = mcp-servers-nix.lib.mkConfig pkgs {
    fileName = "mcp.json";
    programs = import ./mcp-servers/programs.nix { inherit pkgs mcp-servers-nix; };
    settings.servers = {
      linear = import ./mcp-servers/linear { inherit pkgs; };
      kubernetes = import ./mcp-servers/kubernetes { inherit pkgs; };
    };
  };

  settingsJson = pkgs.writeText "pi-settings.json" (builtins.toJSON {
    theme = "light";
    compaction.enabled = false;
    packages = [
      piMcpAdapter
    ];
  });
in
{
  home.packages = [ llm-agents.pi ];

  home.file = {
    ".pi/agent/AGENTS.md".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/agents/AGENTS.md";
    ".pi/agent/mcp.json".source = mcpConfig;
    ".pi/agent/extensions".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/agents/pi/extensions";
    ".pi/agent/agents".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/agents/pi/agents";
    ".pi/agent/prompts".source = mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dot_config/agents/pi/prompts";
  };

  # pi install や /settings が settings.json へ書き込むため symlink にせず実ファイルで配置し、
  # nix 側を正として乖離したら上書きする。
  # グローバルパッケージは起動時に自動インストールされないため、未取得なら pi install を促す
  home.activation.piSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/.pi/agent"
    if ! ${pkgs.diffutils}/bin/cmp -s ${settingsJson} "$HOME/.pi/agent/settings.json" 2>/dev/null; then
      run install -m 644 ${settingsJson} "$HOME/.pi/agent/settings.json"
    fi
    if [ ! -d "$HOME/.pi/agent/npm/pi-mcp-adapter" ]; then
      echo "pi: run once: pi install ${piMcpAdapter}"
    fi
  '';
}
