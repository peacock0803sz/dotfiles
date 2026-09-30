# Pen.app (pen.dev) に同梱された MCP サーバー。Pen.app は Nix 管理外で手動インストールしているため
# /Applications 配下のバイナリを直接指す。Pen.app は macOS にしか無いので darwin 以外では空を返す。
# agent は Pen 側の連携表示に使うラベル (claudeCodeCLI / codexCLI 等)。対応値の無いクライアントは省略する
{ pkgs, lib, agent ? null }:
lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
  pencil = {
    command = "/Applications/Pen.app/Contents/Resources/app.asar.unpacked/out/mcp-server-darwin-arm64";
    args = [ "--app" "desktop" ] ++ lib.optionals (agent != null) [ "--agent" agent ];
  };
}
