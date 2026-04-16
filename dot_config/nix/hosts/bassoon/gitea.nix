{ lib, ... }:
let
  domain = "git.p3ac0ck.net";
  httpPort = 3000;
  nginxPort = 8081;
  tunnelId = "5ac81ddd-325b-4dab-8fc5-c5e4b381f8ab";
in
lib.mkMerge [
  {
    # Gitea {{{
    services.gitea = {
      enable = true;
      appName = "Peacock's Git";

      database = {
        type = "postgres";
        socket = "/run/postgresql";
        name = "gitea";
        user = "gitea";
        createDatabase = true;
      };

      repositoryRoot = "/mnt/Eggplants/ST4000VN006/gitea/repositories";

      lfs = {
        enable = true;
        contentDir = "/mnt/Eggplants/ST4000VN006/gitea/lfs";
      };

      settings = {
        server = {
          DOMAIN = domain;
          ROOT_URL = "https://${domain}/";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = httpPort;
          PROTOCOL = "http";
          SSH_PORT = 22;
          START_SSH_SERVER = false;
        };

        service = {
          DISABLE_REGISTRATION = true;
        };

        session = {
          COOKIE_SECURE = true;
        };

        log = {
          LEVEL = "Info";
        };
      };

      dump = {
        enable = true;
        backupDir = "/mnt/Eggplants/ST4000VN006/gitea/dump";
        interval = "04:31";
        type = "tar.zst";
      };
    };
    # }}}

    # PostgreSQL {{{
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "gitea" ];
      ensureUsers = [
        {
          name = "gitea";
          ensureDBOwnership = true;
        }
      ];
    };
    # }}}

    # Nginx {{{
    services.nginx = {
      enable = true;

      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts.${domain} = {
        listen = lib.mkForce [
          { addr = "127.0.0.1"; port = nginxPort; }
        ];

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString httpPort}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-Proto https;
            client_max_body_size 100m;
          '';
        };
      };
    };
    # }}}

    # systemd {{{
    systemd.services.gitea = {
      after = [ "mnt-Eggplants-ST4000VN006.mount" ];
      wants = [ "mnt-Eggplants-ST4000VN006.mount" ];
      serviceConfig.ReadWritePaths = [ "/mnt/Eggplants/ST4000VN006/gitea" ];
    };

    systemd.tmpfiles.rules = [
      "d /mnt/Eggplants/ST4000VN006/gitea 0750 gitea gitea -"
      "d /mnt/Eggplants/ST4000VN006/gitea/repositories 0750 gitea gitea -"
      "d /mnt/Eggplants/ST4000VN006/gitea/lfs 0750 gitea gitea -"
      "d /mnt/Eggplants/ST4000VN006/gitea/dump 0750 gitea gitea -"
    ];
    # }}}
  }

  # Cloudflare Tunnel {{{
  (lib.mkIf (tunnelId != "") {
    services.cloudflared = {
      enable = true;

      tunnels.${tunnelId} = {
        credentialsFile = "/var/lib/cloudflared/${tunnelId}.json";

        default = "http_status:404";

        ingress = {
          ${domain} = {
            service = "http://127.0.0.1:${toString nginxPort}";
          };
        };
      };
    };

    users.users.cloudflared = {
      isSystemUser = true;
      group = "cloudflared";
      home = "/var/lib/cloudflared";
      description = "Cloudflare Tunnel daemon user";
    };

    users.groups.cloudflared = { };

    systemd.tmpfiles.rules = [
      "d /var/lib/cloudflared 0750 cloudflared cloudflared -"
    ];
  })
  # }}}
]
