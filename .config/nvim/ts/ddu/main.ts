import * as stdpath from "https://deno.land/std@0.208.0/path/mod.ts";
import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
} from "https://deno.land/x/ddu_vim@v3.6.0/types.ts";
import { fn } from "https://deno.land/x/ddu_vim@v3.6.0/deps.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.6.0/base/config.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.7.1/file.ts";
import * as u from "https://deno.land/x/unknownutil@v3.9.0/mod.ts";

type Never = Record<never, never>;

type Params = Record<string, unknown>;
type GitStatusActionData = {
  status: string;
  path: string;
  worktree: string;
};

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.setAlias("action", "tabopen", "open");

    args.contextBuilder.patchGlobal({
      ui: "ff",
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_substring"],
          sorters: ["sorter_fzf"],
          converters: ["converter_hl_dir", "converter_devicon"],
        },
        git_status: {
          converters: ["converter_git_status", "converter_devicon"],
        },
      },
      sourceParams: {
        rg: {
          args: ["--column", "--no-heading", "--color", "never"],
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
        git_commit: { defaultAction: "yank" },
        source: { defaultAction: "execute" },
        git_status: {
          defaultAction: "open",
          actions: {
            diff: async (args) => {
              const action = args.items[0].action as GitStatusActionData;
              const path = stdpath.join(action.worktree, action.path);
              await args.denops.call("ddu#start", {
                name: "file:git_diff",
                sources: [
                  {
                    name: "git_diff",
                    options: {
                      path,
                    },
                    params: {
                      ...(u.maybe(args.actionParams, u.isRecord) ?? {}),
                      onlyFile: true,
                    },
                  },
                ],
              });
              return ActionFlags.None;
            },
            // fire GinPatch command to selected items
            // using https://github.com/lambdalisue/gin.vim
            patch: async (args: ActionArguments<Never>) => {
              for (const item of args.items) {
                const action = item.action as GitStatusActionData;
                await args.denops.cmd("tabnew");
                await args.denops.cmd("tcd " + action.worktree);
                await args.denops.cmd("GinPatch ++no-head " + action.path);
              }
              return ActionFlags.None;
            },
          },
        },
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
