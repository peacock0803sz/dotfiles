# Akkoma (Fediverse server) configuration with Cloudflare Tunnel
{ config, pkgs, lib, ... }:

let
  domain = "social.p3ac0ck.net";
  tunnelId = "5fd84b20-fca9-4d68-a420-fc05a3f9b4d0";
in
{
  # ============================================================================
  # Akkoma Configuration
  # ============================================================================
  services.akkoma = {
    enable = true;

    # Akkoma configuration (config.exs equivalent)
    config = {
      # Instance settings
      ":pleroma" = {
        ":instance" = {
          name = "Peacock's Social";
          description = "Personal Akkoma instance";
          email = "me@${domain}";
          registrations_open = false;
          invites_enabled = false;
          federating = true;
          limit = 5000; # Character limit
        };

        # Web endpoint configuration
        "Pleroma.Web.Endpoint" = {
          url = {
            scheme = "https";
            host = domain;
            port = 443;
          };
        };

        # Upload configuration
        "Pleroma.Upload" = {
          base_url = "https://${domain}/media";
          uploader = (pkgs.formats.elixirConf { }).lib.mkRaw "Pleroma.Uploaders.Local";
        };

        "Pleroma.Uploaders.Local" = {
          uploads = "/var/lib/akkoma/uploads";
        };

        # Database configuration (using local socket)
        "Pleroma.Repo" = {
          adapter = "Ecto.Adapters.Postgres";
          socket_dir = "/run/postgresql";
          database = "akkoma";
          username = "akkoma";
          pool_size = 10;
        };
      };

      # Logger configuration
      ":logger" = {
        ":console" = {
          level = ":info";
        };
      };
    };

    # Use Nginx as the frontend (Akkoma's built-in nginx config)
    nginx = {
      enableACME = false; # Cloudflare handles TLS
      forceSSL = false; # Cloudflare Tunnel handles this
    };

    # Initialize database if needed
    initDb.enable = true;
  };

  # ============================================================================
  # PostgreSQL for Akkoma
  # ============================================================================
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "akkoma" ];
    ensureUsers = [
      {
        name = "akkoma";
        ensureDBOwnership = true;
      }
    ];
  };

  # ============================================================================
  # Nginx Reverse Proxy
  # ============================================================================
  services.nginx = {
    enable = true;

    # Recommended settings for Akkoma
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts.${domain} = {
      # Cloudflare Tunnel connects to localhost (HTTP)
      listen = lib.mkForce [
        { addr = "127.0.0.1"; port = 8080; }
      ];

      # Add default server to catch all requests on this port
      default = lib.mkForce true;

      locations."/" = {
        proxyPass = "http://unix:/run/akkoma/socket";
        proxyWebsockets = true;
        extraConfig = ''
          # Override X-Forwarded-Proto for Cloudflare Tunnel
          proxy_set_header X-Forwarded-Proto https;

          # For large media uploads
          client_max_body_size 50m;
        '';
      };
    };
  };

  # ============================================================================
  # Cloudflare Tunnel
  # ============================================================================
  services.cloudflared = {
    enable = true;

    tunnels.${tunnelId} = {
      # Credentials file created by `cloudflared tunnel create`
      # Store at /var/lib/cloudflared/<tunnel-id>.json
      credentialsFile = "/var/lib/cloudflared/${tunnelId}.json";

      default = "http_status:404";

      ingress = {
        ${domain} = {
          service = "http://127.0.0.1:8080";
        };
      };
    };
  };

  # ============================================================================
  # Cloudflared User and Group
  # ============================================================================
  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
    home = "/var/lib/cloudflared";
    description = "Cloudflare Tunnel daemon user";
  };

  users.groups.cloudflared = { };

  # Ensure cloudflared directory exists with proper permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/cloudflared 0750 cloudflared cloudflared -"
  ];

  # ============================================================================
  # Firewall (internal network only, Cloudflare Tunnel handles external access)
  # ============================================================================
  # Note: No need to open ports externally since Cloudflare Tunnel is used
  # If you want local network access:
  # networking.firewall.allowedTCPPorts = [ 8080 ];
}