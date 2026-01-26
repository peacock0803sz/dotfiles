{ ... }@inputs: {
  launchd.user.agents.lemonade = {
    serviceConfig = {
      EnvironmentVariables = {
        LANG = "ja_JP.UTF-8";
        LC_ALL = "ja_JP.UTF-8";
      };
      ProgramArguments = [
        "${inputs.pkgs.lemonade}/bin/lemonade"
        "server"
        "--allow=0.0.0.0/0"
      ];
      KeepAlive = true;
      StandardErrorPath = "/tmp/lemonade.err.log";
      StandardOutPath = "/tmp/lemonade.out.log";
    };
  };
}
