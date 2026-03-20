# oksskolten - AI-native RSS reader
# https://github.com/babarot/oksskolten
{ pkgs, username, ... }: {
  systemd.services.oksskolten = {
    description = "The AI-native RSS reader; https://github.com/babarot/oksskolten";

    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" "network-online.target" ];
    requires = [ "docker.service" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "simple";
      User = username;
      WorkingDirectory = "/home/${username}/oksskolten";
      ExecStart = "${pkgs.docker}/bin/docker compose up --build";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      Restart = "on-failure";
      RestartSec = 10;
    };
    path = [ pkgs.docker ];
  };
}
