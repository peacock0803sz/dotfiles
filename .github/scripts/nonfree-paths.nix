# nixosConfigurations.<host> / darwinConfigurations.<host> / homeConfigurations.<system>.<preset> を受け取り、
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

  # system 構成なら systemPackages と各ユーザーの home.packages、home 構成単体なら home.packages を見る
  packages = (c.config.environment.systemPackages or [ ])
    ++ lib.concatMap (u: u.home.packages) (lib.attrValues (c.config.home-manager.users or { }))
    ++ (c.config.home.packages or [ ]);
  excluded = lib.filter (p: lib.isDerivation p && (isCask p || isUnfree p)) packages;
in
lib.unique (lib.concatMap
  (p: map (o: builtins.unsafeDiscardStringContext p.${o}.outPath) (p.outputs or [ "out" ]))
  excluded)
