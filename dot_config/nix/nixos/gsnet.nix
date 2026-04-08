{ pkgs, name, ip, ... }: {
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  services.tinc.networks.gsnet = {
    name = name;
    debugLevel = 3;
    chroot = false;

    settings = {
      Mode = "switch";
      Device = "/dev/net/tun";
      ConnectTo = [
        "gsngw01"
        "suzukautako"
        "linuweb"
        "nagasaki"
        "rabbit_house"
        "chiyomomo"
      ];
    };

    hostSettings = {
      gsngw01 = {
        addresses = [{ address = "153.127.23.44"; port = 655; }];
        rsaPublicKey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIIBCgKCAQEAs//3ZYJ7+cWRptqA/I6gzpvLL8DEG20pJYSMx6xcPunfazBnKb3w
          ctz5xwJqTMpYzUQwTs0aIVqF/Rf3+yAIs/UPA1ToX3q3Lq588wIeIJ9R2jr9LOpU
          o7dgDrE3GDdhOutgbGHqxWzsXlYVfQ1OLQtZFkyAJU5teK++cWmqpL15liZ+JxrI
          Gkh+NnUVR1DJMh1eEWg/sZMYzIFKZ71BBduhDPo1vYzL83iqwB8LoKDNehd/zzSK
          mBcxFLb8Bf2ob6c13cyISeFhuWVQMvV0HLDdddHUgBZqhPj9qmUSlnQ+EUHeiVRf
          2DkrYX2zMIQ+FP0WCT9BdjVA/ZKnX72dtwIDAQAB
          -----END RSA PUBLIC KEY-----
        '';
      };

      suzukautako = {
        addresses = [{ address = "140.227.70.225"; port = 655; }];
        rsaPublicKey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIIBCgKCAQEAzzPh12lCjoWmnkyOFxQ4+ySQQ4WcYh11AdOoyGLTZCX3yA+jH6NO
          2EJ6hx4kdvSEQfU1YRR5FJkD28nNsKYAoMhEsbRIJjn/uTCTw0NHFw6MbfDPgTlK
          vqNhijTY3h3Z5mtciMm5Ooow4ZXywih3Ty2c8Gvc77jMMlWtZ+ay6XsSvFT26Cit
          oFzKf2uGUT6JoibzTjZcXwfq/aMB4HDG5p5gpA80uYxrwbDnH5TTw6ZbKN2A0IZh
          xgr5thmIcn+ihGgbJThZhQJ+UfRSlEYOx1TH5oRhUgcWvnNCuDpD7N2MAtZFSGPA
          ouErT6lQ9C5K0qVk6n7Ou8UkvcZHO4qBaQIDAQAB
          -----END RSA PUBLIC KEY-----
        '';
      };

      linuweb = {
        addresses = [{ address = "dolphin-net.mydns.jp"; port = 655; }];
        rsaPublicKey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIIBCgKCAQEA2U/CoLlNVBbbVmZthMJY874szpLNkxVzfKt0N5xaIyqd2x1fapev
          OQjtodz1OnriyeL8hfVaHgqzDjpkWsCbdWrE1xqPZO5h66utspug6qbII4ntXXbq
          KWUpM+6fZu0qtmp7hSCU//wJIqBGDC5AcQqmUdpY3Kv4knxQ5/F0g4XUyMrn58YM
          4m+04UZ9OOQGgpyX4e2vS3VDN76Y/dbR+a8nzbhIcmPVzQhkqPcrC24fwYukvsjx
          VGzpoWRx9iYbayS2D6hv5auhL1JBI4Zx+uNBuhIz4dAMMSyIksW9PthQsMPZbW+x
          2Ga4SZlJDgLCLOpt8FPdccTWbo27dwpVGwIDAQAB
          -----END RSA PUBLIC KEY-----
        '';
      };

      nagasaki = {
        addresses = [{ address = "nagasaki.hiyoco.club"; port = 655; }];
        rsaPublicKey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIIBCgKCAQEA/hZ2f4TyZMHVuZ0xBaQFpqqGKM0fzSeWWbRO7/Tu/bnphPXnkKJy
          oJ155eklyy1lc+Syt+MWs+epbyZz1dJZMLkf4b7Bi+M46bDrCYdod4P1KZsFfjFL
          Pju/vthOEF3T3Wc8iQo7VcSM1IBu/ILBN+LPWiYRBf3+BDtRD1C1+lT5YR0DJaWO
          rqD9Al+4XnPIjLUy0gw5h4+joC7FD2X2fbTksD+fk5rgysXlU/C6AncRU7U7iTBh
          HJAoR6wVk4uf533Ri4C6wqAVUdUYNfGJCKf24is+Oun046iBUWu+fY6wCrdKpyGq
          w97eARBoit60i6Z/coiYqBrYmewR0tSMzwIDAQAB
          -----END RSA PUBLIC KEY-----
        '';
      };

      rabbit_house = {
        addresses = [{ address = "rabbit-house.smdr.io"; port = 655; }];
        rsaPublicKey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIIBCgKCAQEA2YqqCPwg9NgiYbUkHtGhUwQ83u0aIqLNdxeFBX8BatP1hVzXEUAW
          /EzLV9SzvkAMKrYypiiJpS9mZ+hctuvGiA5Ci72txrrWW+/UHix9cAHinHRMkBCq
          9MF8BzWsOfhyfcpBozRGfBscoBtq3w408m+YnNzp6hv8Q+nbQgWGYEj7P2PW3PUe
          wVyh3oOu8PPtaRD1RYgoPdfzkYXmcJTVQFheuZ5dG3vZV3ttlghD9YrQSepzGpyG
          X9sorXTYsVs/MJ2gNYGdvuoLJzAWsVNReeVmXC2R/arbtvWmM7QhTkIt7yyOiovh
          f9gnQBP7NW0dNuP0jdQAt/2RU5KmXpoJJwIDAQAB
          -----END RSA PUBLIC KEY-----
        '';
      };

      chiyomomo = {
        addresses = [{ address = "chiyomomo.sz7.jp"; port = 655; }];
        rsaPublicKey = ''
          -----BEGIN RSA PUBLIC KEY-----
          MIIBCgKCAQEAvWHbmjKdpbvJHgIABzKPl33YAmxkUKwdoSTkKJiygjYTDK9ufOW7
          oMvtlflYzFoQ3hU4OjG9LBFTBYcTTIW0sgSz+/fKhoW/RMnKJKhVgUXVSMpNxCSd
          FvmmnoXm3ZQqvVH5sNFLnVmq43M41tx8O5y6qn4on/g428Z+nd9RCmQYObIhiEbt
          cCO91IONa16CWMNU1o6NFTgXOhmUwdDw+3tzusCp5WDOrkopSr3NAAwG1OOoKRLa
          Me+yOR1+mxEEElIdVCM5HEIgYZvZn0lfhCQCpBRORKyE7V9XUZB6EPdi9xNLR85d
          QcK8rFtHLVtVAMVQ7PtA9vHCXtNsFHTWZwIDAQAB
          -----END RSA PUBLIC KEY-----
        '';
      };
    };
  };

  # tinc-up: ブリッジ作成 + NAT設定
  environment.etc."tinc/gsnet/tinc-up" = {
    mode = "0755";
    text = ''
      #!/bin/sh
      ${pkgs.iproute2}/bin/ip link add br0 type bridge
      ${pkgs.iproute2}/bin/ip link set br0 up
      ${pkgs.iproute2}/bin/ip link set $INTERFACE up
      ${pkgs.iproute2}/bin/ip link set dev $INTERFACE master br0
      ${pkgs.iproute2}/bin/ip link set dev eth1 master br0
      ${pkgs.iproute2}/bin/ip addr add ${ip}/8 dev br0
      ${pkgs.iptables}/bin/iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A FORWARD -i br0 -o eth0 -j DROP
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o br0 -j MASQUERADE
    '';
  };

  # tinc-down: NAT解除 + ブリッジ削除
  environment.etc."tinc/gsnet/tinc-down" = {
    mode = "0755";
    text = ''
      #!/bin/sh
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o br0 -j MASQUERADE 2>/dev/null || true
      ${pkgs.iptables}/bin/iptables -D FORWARD -i br0 -o eth0 -j DROP 2>/dev/null || true
      ${pkgs.iptables}/bin/iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true
      ${pkgs.iptables}/bin/iptables -D INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true
      ${pkgs.iproute2}/bin/ip link set dev $INTERFACE nomaster
      ${pkgs.iproute2}/bin/ip link set dev $INTERFACE down
      ${pkgs.iproute2}/bin/ip link set dev eth1 nomaster
      ${pkgs.iproute2}/bin/ip link set dev br0 down
      ${pkgs.iproute2}/bin/ip link del dev br0
    '';
  };

  environment.systemPackages = [ pkgs.iptables ];
}
