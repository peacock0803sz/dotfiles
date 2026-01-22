{ ... }@inputs: {
  launchd.user.agents = {
    notizen = {
      serviceConfig = {
        EnvironmentVariables = {
          HOME = "/Users/${inputs.username}";
          NOTIZEN_REMOTE_HOST = "enigma.tail2121a.ts.net";
          NOTIZEN_REMOTE_USER = "${inputs.username}";
          NOTIZEN_REMOTE_KEY = "/Users/${inputs.username}/.ssh/id_ed25519";
          NOTIZEN_REMOTE_PATH = "/home/${inputs.username}/notizen/source/";
        };
        ProgramArguments = [
          "/Users/${inputs.username}/notizen/.venv/bin/notizen"
          "sync"
          "--src=/Users/${inputs.username}/notizen/source"
        ];
        StartInterval = 3600;
        WorkingDirectory = "/Users/${inputs.username}/notizen";
        StandardErrorPath = "/tmp/notizen.err.log";
        StandardOutPath = "/tmp/notizen.out.log";
      };
    };
  };
}
