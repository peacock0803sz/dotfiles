{ pkgs, lib, ... }:
let
  envFile = "/var/lib/anyconnect/env";
  passwordFile = "/var/lib/anyconnect/password";

  corpSubnets = [ "172.21.0.0/16" "172.22.0.0/16" ];

  lanInterface = "enp1s0";

  vpncNoDns = pkgs.writeShellScript "vpnc-no-dns" ''
    unset INTERNAL_IP4_DNS INTERNAL_IP6_DNS CISCO_DEF_DOMAIN CISCO_BANNER
    exec ${pkgs.vpnc-scripts}/bin/vpnc-script "$@"
  '';
in
{
  systemd.services.anyconnect = {
    description = "AnyConnect VPN to Office";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      EnvironmentFile = envFile;
      ExecStart = pkgs.writeShellScript "openconnect-corp-up" ''
        exec ${pkgs.openconnect}/bin/openconnect \
          --no-dtls \
          --script=${vpncNoDns} \
          --servercert="$ANYCONNECT_FINGERPRINT" \
          --user="$ANYCONNECT_USER" \
          --passwd-on-stdin \
          "$ANYCONNECT_SERVER" \
          < ${passwordFile}
      '';
      Restart = "always";
      RestartSec = 5;
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.nat = {
    enable = true;
    externalInterface = "tun0";
    internalInterfaces = [ lanInterface "tailscale0" ];
  };

  services.tailscale = {
    useRoutingFeatures = "server";
    extraSetFlags = [
      "--advertise-routes=${lib.concatStringsSep "," corpSubnets}"
      "--accept-dns=false"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/anyconnect 0700 root root - -"
  ];

  environment.systemPackages = with pkgs; [
    openconnect
    vpnc-scripts
    iproute2
    iptables
  ];
}
