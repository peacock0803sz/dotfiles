# OpenPencil (openpencil.dev) の MCP サーバーと Pi 用の Harness companion。
# どちらも nixpkgs に無いので npx で起動するラッパーを同名コマンドで用意する。
# OpenPencil.app の guided setup は PATH 上のコマンドを探すため、ラッパーは home.packages にも入れる。
# MCP サーバーは起動中のデスクトップアプリを自動検出して接続する
{ pkgs, lib }:
let
  # パッケージに bin が複数あることがあるので -p で実行する bin を明示する。
  # bin は `#!/usr/bin/env node` なので、PATH が最小の GUI 起動でも node を見つけられるようにする
  npxBin = package: bin: pkgs.writeShellScriptBin bin ''
    export PATH=${lib.makeBinPath [ pkgs.nodejs ]}:$PATH
    exec npx -y -p ${package} ${bin} "$@"
  '';
in
rec {
  mcp = npxBin "@open-pencil/mcp" "openpencil-mcp";
  harness = npxBin "@open-pencil/harness" "openpencil-harness";
  server.open-pencil.command = lib.getExe mcp;
}
