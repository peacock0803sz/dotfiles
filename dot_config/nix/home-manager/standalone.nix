# preset を単体の home-manager 構成として評価する (CI のキャッシュビルド用)。
# platforms/* は含めない (darwin.nix は Lanterna と brew cask を持ち込み、runner で落ちる)。
# hostName は codex / claude-code の "arpeggio" 判定にしか使われないのでダミーを渡す。
{ inputs, system, preset }:
let
  inherit (inputs) nixpkgs;
  username = "peacock";
  pkgs = import nixpkgs {
    inherit system;
    config = import ../nixpkgs.nix;
    overlays = [
      inputs.neovim-overlay.overlays.default
      inputs.nur.overlays.default
    ];
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit inputs system; hostName = "preset-${preset}"; };
  modules = [
    ./.
    (./presets + "/${preset}.nix")
    {
      home.username = username;
      home.homeDirectory =
        if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
    }
  ];
}
