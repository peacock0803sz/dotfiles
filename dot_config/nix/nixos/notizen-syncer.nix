{ pkgs, username, ... }: {
  systemd.user.services.notizen = {
    description = "notizen periodic commit";
    environment = {
      HOME = "/home/${username}";

      # 1Password の op-ssh-sign は GUI 承認を要求するため systemd 配下では固まる。
      # 同じ鍵がパスフレーズなしのファイルとして存在するので ssh-keygen 署名に
      # 差し替える(NixOS 側 .gitconfig.nixos と同じ方式)。
      # GIT_CONFIG_* は設定ファイルより優先される
      GIT_CONFIG_COUNT = "2";
      GIT_CONFIG_KEY_0 = "gpg.ssh.program";
      GIT_CONFIG_VALUE_0 = "${pkgs.openssh}/bin/ssh-keygen";
      GIT_CONFIG_KEY_1 = "user.signingkey";
      GIT_CONFIG_VALUE_1 = "/home/${username}/.ssh/id_ed25519";

      # push 先は insteadOf で ssh://gitea@bassoon:2222/ に書き換わる。
      # SSH_AUTH_SOCK の無い systemd でも確実に鍵を使えるよう明示する
      GIT_SSH_COMMAND =
        "${pkgs.openssh}/bin/ssh -i /home/${username}/.ssh/id_ed25519 -o IdentitiesOnly=yes";
    };
    # notizen は git を exec.LookPath で探す。systemd の PATH に nix profile は無い
    path = [ pkgs.git pkgs.openssh ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.nur.repos.peacock0803sz.notizen}/bin/notizen commit --root=/home/${username}/notizen";
      WorkingDirectory = "/home/${username}/notizen";
    };
  };

  systemd.user.timers.notizen = {
    description = "notizen periodic commit timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
      Unit = "notizen.service";
    };
  };
}
