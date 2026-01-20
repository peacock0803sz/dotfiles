{ ... }@inputs: {
  launchd.labelPrefix = "net.p3ac0ck.nix";
  launchd.user.agents = {
    lemonade = {
      serviceConfig = {
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
  };
}
