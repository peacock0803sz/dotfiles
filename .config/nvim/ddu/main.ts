import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
} from "https://deno.land/x/ddu_vim@v3.4.4/types.ts";
import { fn } from "https://deno.land/x/ddu_vim@v3.4.4/deps.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.4.4/base/config.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.5.2/file.ts";

type Params = Record<string, unknown>;

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.setAlias("source", "file_rg", "file_external");
    args.setAlias("action", "tabopen", "open");

    args.contextBuilder.patchGlobal({
      ui: "ff",
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_substring"],
          sorters: ["sorter_fzf"],
          converters: ["converter_hl_dir"]
        },
        file: {
          ignoreCase: true,
          columns: ["icon_filename"],
        },
      },
      sourceParams: {
        rg: {
          args: [
            "--ignore-case",
            "--column",
            "--no-heading",
            "--color",
            "never",
          ],
        },
        file_rg: {
          cmd: [
            "rg",
            "--files",
            "--glob",
            "!.git",
            "--color",
            "never",
            "--no-messages",
          ],
          updateItems: 50000,
        },
      },
      filterParams: {
        matcher_fzf: { highlightMatched: "DduSearchMatched" },
        matcher_substring: { highlightMatched: "Search" },
      },
      kindOptions: {
        git_commit: { defaultAction:  "yank"},
        file: {
          defaultAction: "open",
          actions: {
            grep: async (args: ActionArguments<Params>) => {
              const action = args.items[0]?.action as ActionData;

              await args.denops.call("ddu#start", {
                name: args.options.name,
                push: true,
                sources: [
                  {
                    name: "rg",
                    options: {
                      machers: [],
                      volatile: true,
                    },
                    params: {
                      path: action.path,
                      input: await fn.input(args.denops, "Pattern: "),
                    },
                  },
                ],
              });

              return Promise.resolve(ActionFlags.None);
            },

            uiCd: async (args: ActionArguments<Params>) => {
              const action = args.items[0]?.action as ActionData;

              await args.denops.call("ddu#ui#do_action", {
                name: "narrow",
                params: {
                  path: action.path,
                },
              });

              return Promise.resolve(ActionFlags.None);
            },
          },
        },
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
