import { BaseConfig, ConfigArguments } from "./deps.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.setAlias("action", "tabopen", "open");

    args.contextBuilder.patchGlobal({
      resume: true,
      ui: "ff",
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_fzf"],
          sorters: ["sorter_fzf"],
          converters: ["converter_hl_dir", "converter_devicon"],
        },
        git_status: {
          converters: ["converter_git_status", "converter_devicon"],
        },
        git_diff: {
          converters: [],
        },
        rg: {
          volatile: true,
          matchers: ["matcher_fzf"],
          sorters: ["sorter_fzf"],
          converters: ["converter_devicon"],
        },
      },
      sourceParams: {
        rg: {
          args: [
            "--column",
            "--no-heading",
            "--color",
            "never",
            "--hidden",
            "--glob=!.git"
          ],
        },
        file_external: {
          cmd: [
            "fd",
            "--type",
            "f",
            "--hidden",
            "--follow",
            "--exclude",
            ".git",
          ],
        },
      },
      filterParams: {
        matcher_fzf: { highlightMatched: "DduSearchMatched" },
        matcher_substring: { highlightMatched: "Search" },
      },
      kindOptions: {
        _: { defaultAction: "open" },
        git_commit: { defaultAction: "yank" },
        source: { defaultAction: "execute" },
        "ai-review-request": { defaultAction: "open" },
        "ai-review-log": { defaultAction: "resume" },
        action: {
          defaultAction: "do",
        },
      },
      kindParams: {
        action: {
          quit: true,
        },
      },
      actionOptions: {
        narrow: {
          quit: false,
        },
        tabopen: {
          quit: false,
        },
      },
    });
    return Promise.resolve();
  }
}
