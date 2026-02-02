{ pkgs, ... }@inputs:
{
  systemd.services.lemonade = {
    description = "Lemonade clipboard server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      User = inputs.username;
      Environment = [
        "LANG=ja_JP.UTF-8"
        "LC_ALL=ja_JP.UTF-8"
      ];
      ExecStart = "${pkgs.lemonade}/bin/lemonade server --allow=0.0.0.0/0";
      Restart = "always";
      RestartSec = 5;
      StandardOutput = "append:/tmp/lemonade.out.log";
      StandardError = "append:/tmp/lemonade.err.log";
    };
  };
}
