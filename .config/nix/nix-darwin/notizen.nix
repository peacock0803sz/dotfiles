{ username, ... }: {
  launchd.user.agents = {
    notizen = {
      serviceConfig = {
        EnvironmentVariables = {
          HOME = "/Users/${username}";
          NOTIZEN_REMOTE_HOST = "enigma.tail2121a.ts.net";
          NOTIZEN_REMOTE_USER = "${username}";
          NOTIZEN_REMOTE_KEY = "/Users/${username}/.ssh/id_ed25519";
          NOTIZEN_REMOTE_PATH = "/home/${username}/notizen/source/";
        };
        ProgramArguments = [
          "/Users/${username}/notizen/.venv/bin/notizen"
          "sync"
          "--src=/Users/${username}/notizen/source"
        ];
        StartInterval = 300; # every 5 minutes
        WorkingDirectory = "/Users/${username}/notizen";
        StandardErrorPath = "/tmp/notizen.err.log";
        StandardOutPath = "/tmp/notizen.out.log";
      };
    };
  };
}
