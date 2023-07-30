import { BaseConfig } from "https://deno.land/x/ddu_vim@v3.4.4/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.4.4/base/config.ts";
import { Params as FfParams } from "https://deno.land/x/ddu_ui_ff@v1.1.0/ff.ts";
import * as opt from "https://deno.land/x/denops_std@v5.0.1/option/mod.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const winCol = await opt.columns.get(args.denops);
    const winRow = await opt.lines.get(args.denops);
    const winWidth = Math.floor(winCol * 0.95);
    const winHeight = Math.floor(winRow * 0.8);

    const mayVSplit = winCol >= 100; // 100以上なら縦分割

    args.contextBuilder.patchGlobal({
      ui: "ff",
      uiParams: {
        ff: {
          split: "floating",
          filterFloatingPosition: "bottom",
          filterSplitDirection: "botright",
          floatingBorder: "single",
          prompt: ">",
          autoAction: { name: "preview", delay: 1 },
          startAutoAction: true,
          previewFloating: true,
          previewFloatingBorder: "single",
          previewSplit: mayVSplit ? "vertical" : "horizontal",
          filterUpdateTime: 0,
          winHeight: winHeight,
          winRow: 2,
          winWidth: winWidth,
          winCol: 0,
          previewWidth: mayVSplit ? Math.floor(winWidth / 2) : winWidth,
          previewHeight: winHeight,
        } satisfies Partial<FfParams>,
      },
    });
    return Promise.resolve();
  }
}
