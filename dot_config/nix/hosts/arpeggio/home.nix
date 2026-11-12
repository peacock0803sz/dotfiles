{ pkgs, lib, config, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  jq = lib.getExe pkgs.jq;
  xdgCacheDir = "/Volumes/Cache/xdg-cache";
  orbstackDataDir = "/Volumes/Cache/orbstack";
  tartHomeDir = "/Volumes/Cache/tart";
in
{
  # tartはVMとpullしたイメージをTART_HOME配下に置く(未設定なら~/.tart)
  home.sessionVariables.TART_HOME = tartHomeDir;

  home.packages = with pkgs; [
    brewCasks.chatgpt
    (brewCasks.claude.overrideAttrs (oldAttrs: {
      postFixup = (oldAttrs.postFixup or "") + ''
        rm -f $out/bin/claude
      '';
    }))
    brewCasks.finetune
  ];

  home.file = {
    ".config/ghostty/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/ghostty/arpeggio.config";
    "Library/Application Support/felis/config.toml".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/felis/arpeggio.toml";
    ".ssh/config".source = mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dot_config/ssh/arpeggio.override.config";

    ".cache".source = mkOutOfStoreSymlink xdgCacheDir;
    # ~/.cacheを丸ごとリンクにするので、xdgモジュールが置く~/.cache/.keepと衝突する
    "${config.xdg.cacheHome}/.keep".enable = false;
  };

  # リンク先が無いままswitchすると、今の~/.cacheが~/.cache.bk.nixへ退避され、中身のないリンクだけが残る
  home.activation.checkCacheVolume = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    if [[ ! -d "${xdgCacheDir}" ]]; then
      errorEcho "${xdgCacheDir}がありません。Cacheボリュームのマウントと~/.cacheのコピーを確認してください"
      exit 1
    fi
  '';

  # vmconfig.jsonにはGUIで変えた設定も入るので、data_dirだけをマージする。
  # データを移す前に書くとOrbStackは空のイメージで起動し、起動中に書くとその後の変更が旧位置に残るので、
  # 移したデータがあり、OrbStackが止まっているときだけ書く
  home.activation.orbstackDataDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    pinOrbstackDataDir() {
      local vmconfig="$HOME/.orbstack/vmconfig.json"
      local current="" tmp
      if [[ -f $vmconfig ]] && ! current="$(${jq} -r '.data_dir // empty' "$vmconfig")"; then
        warnEcho "$vmconfigを読めないので、data_dirは変えません"
        return
      fi
      if [[ $current == "${orbstackDataDir}" ]]; then
        return
      fi
      if [[ ! -e "${orbstackDataDir}/data.img.raw" && ! -e "${orbstackDataDir}/data.img" ]]; then
        warnEcho "${orbstackDataDir}にOrbStackのデータが無いので、data_dirは変えません"
        return
      fi
      if /usr/bin/pgrep -qf 'OrbStack.app/Contents/'; then
        warnEcho "OrbStackが起動中なので、data_dirは変えません。終了してからswitchし直してください"
        return
      fi

      tmp="$(mktemp)"
      if [[ -f $vmconfig ]]; then
        ${jq} --tab --arg d "${orbstackDataDir}" '.data_dir = $d' "$vmconfig" > "$tmp"
      else
        run install -d -m 700 "$HOME/.orbstack"
        ${jq} -n --tab --arg d "${orbstackDataDir}" '{data_dir: $d}' > "$tmp"
      fi
      run mv "$tmp" "$vmconfig"
      rm -f "$tmp"
    }
    pinOrbstackDataDir
  '';
}
