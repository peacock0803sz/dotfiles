import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
} from "https://deno.land/x/ddu_vim@v3.3.3/types.ts";
import { fn } from "https://deno.land/x/ddu_vim@v3.3.3/deps.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.3.3/base/config.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.5.2/file.ts";
import { Params as FfParams } from "https://deno.land/x/ddu_ui_ff@v1.0.2/ff.ts";
import { Params as FilerParams } from "https://deno.land/x/ddu_ui_filer@v1.0.2/filer.ts";
import * as opt from "https://deno.land/x/denops_std@v5.0.1/option/mod.ts";

type Params = Record<string, unknown>;

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    args.setAlias("source", "file_rg", "file_external");
    args.setAlias("action", "tabopen", "open");

    const winCol = await opt.columns.get(args.denops);
    const winRow = await opt.lines.get(args.denops);
    const winWidth = Math.floor(winCol * 0.95);
    const winHeight = Math.floor(winRow * 0.8);

    const mayVSplit = winWidth >= 88; // 88以上なら縦分割

    args.contextBuilder.patchGlobal({
      ui: "ff",
      uiOptions: {
        filer: {
          toggle: true,
        },
      },
      uiParams: {
        ff: {
          split: "floating",
          startFilter: true,
          filterFloatingPosition: "bottom",
          filterSplitDirection: "botright",
          floatingBorder: "single",
          prompt: ">",
          autoAction: { name: "preview" },
          previewFloating: true,
          previewFloatingBorder: "single",
          previewSplit: mayVSplit ? "vertical" : "horizontal",
          updateTime: 0,
          winHeight: winHeight,
          winRow: 2,
          winWidth: winWidth,
          winCol: 0,
          previewWidth: mayVSplit ? Math.floor(winWidth / 2) : winWidth,
        } as Partial<FfParams>,
        filer: {
          sort: "filename",
          sortTreesFirst: true,
          split: "floating",
          toggle: false,
          prompt: ">",
          previewFloating: true,
          previewFloatingBorder: "single",
          previewSplit: mayVSplit ? "vertical" : "horizontal",
          winHeight: winHeight,
          winRow: 2,
          winWidth: winWidth,
          winCol: 0,
          previewWidth: mayVSplit ? Math.floor(winWidth / 2) : winWidth,
        } as Partial<FilerParams>,
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_fzf"],
          sorters: ["sorter_fzf"],
        },
      },
      sourceParams: {
        rg: {
          args: [
            // "--ignore-case",
            // "--column",
            // "--no-heading",
            // "--color",
            // "never",
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
      },
      kindOptions: {
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
