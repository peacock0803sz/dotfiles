{ lib, config, ... }:
let
  order = [ "tiny" "small" "large" "huge" ];
in
{
  options.profile = {
    levels = lib.mkOption {
      type = lib.types.listOf (lib.types.enum order);
      default = [ ];
      internal = true;
      description = "各presetが自分のレベルを積む。リスト型なのでマージしても衝突しない";
    };

    level = lib.mkOption {
      type = lib.types.enum order;
      readOnly = true;
      description = "積まれたレベルのうち最上位のもの";
    };
  };

  config.profile.level =
    let
      matched = lib.filter (l: lib.elem l config.profile.levels) order;
    in
    if matched == [ ] then "tiny" else lib.last matched;
}
