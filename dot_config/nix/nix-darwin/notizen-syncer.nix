{ pkgs, username, ... }: {
  launchd.user.agents = {
    notizen = {
      serviceConfig = {
        EnvironmentVariables = {
          HOME = "/Users/${username}";

          # 1Password の op-ssh-sign は GUI 承認を要求するため launchd 配下では固まる。
          # 同じ鍵がパスフレーズなしのファイルとして存在するので ssh-keygen 署名に
          # 差し替える(NixOS 側 .gitconfig.nixos と同じ方式)。
          # GIT_CONFIG_* は設定ファイルより優先される
          GIT_CONFIG_COUNT = "2";
          GIT_CONFIG_KEY_0 = "gpg.ssh.program";
          GIT_CONFIG_VALUE_0 = "${pkgs.openssh}/bin/ssh-keygen";
          GIT_CONFIG_KEY_1 = "user.signingkey";
          GIT_CONFIG_VALUE_1 = "/Users/${username}/.ssh/id_ed25519";

          # push 先は insteadOf で ssh://gitea@bassoon:2222/ に書き換わる。
          # SSH_AUTH_SOCK の無い launchd でも確実に鍵を使えるよう明示する
          GIT_SSH_COMMAND =
            "${pkgs.openssh}/bin/ssh -i /Users/${username}/.ssh/id_ed25519 -o IdentitiesOnly=yes";

          # notizen は git を exec.LookPath で探す。launchd の PATH に nix profile は無い
          PATH = "${pkgs.git}/bin:${pkgs.openssh}/bin:/usr/bin:/bin";
        };
        ProgramArguments = [
          "${pkgs.nur.repos.peacock0803sz.notizen}/bin/notizen"
          "commit"
          "--root=/Users/${username}/notizen"
        ];
        StartInterval = 300; # every 5 minutes
        WorkingDirectory = "/Users/${username}/notizen";
        StandardErrorPath = "/tmp/notizen.err.log";
        StandardOutPath = "/tmp/notizen.out.log";
      };
    };
  };
}
