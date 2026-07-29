{ pkgs, username, ... }: {
  launchd.user.agents.bookmark-syncer = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.uv}/bin/uv"
        "run"
        "--script"
        "/Users/${username}/dotfiles/bin/bookmark-syncer"
        "--all"
      ];
      # uv のキャッシュ位置を確定させるため、launchd 任せにせず明示する
      EnvironmentVariables = {
        HOME = "/Users/${username}";
      };
      # Vivaldi が保存した直後に走らせる
      WatchPaths = [
        "/Users/${username}/Library/Application Support/Vivaldi/Default/Bookmarks"
        "/Users/${username}/Library/Application Support/Vivaldi/Profile 1/Bookmarks"
        "/Users/${username}/Library/Application Support/Vivaldi/Profile 2/Bookmarks"
      ];
      # Chromium はブックマークを rename で差し替えるため WatchPaths が
      # 取りこぼすことがある。その保険
      StartInterval = 900;
      StandardErrorPath = "/tmp/bookmark-syncer.err.log";
      StandardOutPath = "/tmp/bookmark-syncer.out.log";
    };
  };
}
