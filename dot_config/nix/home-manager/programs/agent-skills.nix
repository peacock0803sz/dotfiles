# agent-skills sub-flake のモジュールに、dotfiles 内の local-skills を結び付けて読み込む。
# sub-flake は path input として単体で store に入り親リポジトリを辿れないため、path はこちらで与える
{ inputs, ... }: {
  imports = [
    inputs.agent-skills.homeManagerModules.upstream
    inputs.agent-skills.homeManagerModules.config
  ];

  programs.agent-skills.sources.local.path = ../../../agents/local-skills;
}
