# nixosConfigurations.<host> / darwinConfigurations.<host> を受け取り、
# 公開キャッシュに載せてはいけないパッケージ (brew cask と unfree) の出力パスを返す。
# 見るのは直接インストールしたもの (systemPackages と home-manager の home.packages) だけで、
# 依存の奥に入った unfree は拾えない。
# 使い方: nix eval --json .#<config> --apply "$(cat nonfree-paths.nix)"
c:
let
  inherit (c.pkgs) lib;

  # brew-nix の cask は stdenv.mkDerivation の pname 位置が casks.nix を指す
  brewNix = builtins.unsafeDiscardStringContext (c._module.specialArgs.inputs.brew-nix.outPath or "/nonexistent");
  isCask = p: lib.hasPrefix "${brewNix}/casks.nix" (p.meta.position or "");
  isUnfree = p: lib.any (l: !(l.free or true)) (lib.toList (p.meta.license or [ ]));

  packages = c.config.environment.systemPackages
    ++ lib.concatMap (u: u.home.packages) (lib.attrValues c.config.home-manager.users);
  excluded = lib.filter (p: lib.isDerivation p && (isCask p || isUnfree p)) packages;
in
lib.unique (lib.concatMap
  (p: map (o: builtins.unsafeDiscardStringContext p.${o}.outPath) (p.outputs or [ "out" ]))
  excluded)
