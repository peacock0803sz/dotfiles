# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ ... }@inputs:
{
  services = {
    nginx = {
      enable = true;
      virtualHosts."notizen.p3ac0ck.net" = {
        acmeRoot = null;
        forceSSL = true;
        useACMEHost = "notizen.p3ac0ck.net";
        # enableACME = true;
        listenAddresses = [ "0.0.0.0" "[::1]" ];
        locations."/" = {
          root = "/var/www/notizen/";
          index = "index.html";
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "me@p3ac0ck.net";

    certs."notizen.p3ac0ck.net" = {
      dnsProvider = "cloudflare";
      group = inputs.config.services.nginx.group;
      environmentFile = "/var/lib/acme/cloudflare.env";
    };
  };
  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";

  # Periodic build and deploy for notizen documentation
  systemd.services.notizen-build = {
    description = "Build notizen documentation";
    wants = [ "notizen-deploy.service" ];
    before = [ "notizen-deploy.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = inputs.username;
      WorkingDirectory = "/home/${inputs.username}/notizen";
      # flock で重複実行を防止（タイマーとwatchexecの同時トリガー対策）
      ExecStart = "${inputs.pkgs.flock}/bin/flock -n /tmp/notizen-build.lock -c 'source .venv/bin/activate.fish && ${inputs.pkgs.gnumake}/bin/make html'";
    };
    path = [ inputs.pkgs.bash inputs.pkgs.gnumake ];
  };

  systemd.services.notizen-deploy = {
    description = "Deploy notizen to web server";
    after = [ "notizen-build.service" ];
    requires = [ "notizen-build.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = inputs.username;
      WorkingDirectory = "/home/${inputs.username}/notizen";
      ExecStartPre = "+${inputs.pkgs.coreutils}/bin/chown -R ${inputs.username}:nginx /var/www/notizen";
      ExecStart = "${inputs.pkgs.rsync}/bin/rsync -av --delete build/html/ /var/www/notizen/";
    };
    path = [ inputs.pkgs.rsync ];
  };

  systemd.timers.notizen-build = {
    description = "Timer for notizen build";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };

  systemd.services.notizen-watch = {
    description = "Watch notizen source for changes and trigger build";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      User = inputs.username;
      Restart = "always";
      RestartSec = 5;
      ExecStart = inputs.pkgs.writeShellScript "notizen-watch" ''
        ${inputs.pkgs.watchexec}/bin/watchexec -w /home/${inputs.username}/notizen/source --no-vcs-ignore -- \
            sudo systemctl start --no-block notizen-build.service
      '';
    };
  };

  systemd.services.notizen-commit = {
    description = "Commit & push notizen";
    serviceConfig = {
      Type = "oneshot";
      User = inputs.username;
      WorkingDirectory = "/home/${inputs.username}/notizen";
      ExecStart = inputs.pkgs.writeShellScript "notizen-commit" ''
        set -euo pipefall
        git pull
        git add source/
        git commit -m "Sync source/ at $(${inputs.pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M')"
        git push origin main
      '';
    };
    path = [ inputs.pkgs.coreutils inputs.pkgs.git ];
  };

  systemd.timers.notizen-commit = {
    description = "Timer for notizen commit";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      AccuracySec = "1min";
      Persistent = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/www/notizen 0755 ${inputs.username} nginx -"
  ];
}
