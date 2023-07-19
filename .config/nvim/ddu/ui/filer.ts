import { BaseConfig } from "https://deno.land/x/ddu_vim@v3.3.3/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.3.3/base/config.ts";
import { Params as FilerParams } from "https://deno.land/x/ddu_ui_filer@v1.0.2/filer.ts";
import * as opt from "https://deno.land/x/denops_std@v5.0.1/option/mod.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
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
        filer: {
          sort: "filename",
          sortTreesFirst: true,
          split: "floating",
          prompt: ">",
          autoAction: { name: "preview", delay: 1 },
          startAutoAction: true,
          previewFloating: true,
          previewFloatingBorder: "single",
          previewSplit: mayVSplit ? "vertical" : "horizontal",
          winHeight: winHeight,
          winRow: 2,
          winWidth: winWidth,
          winCol: 0,
          previewWidth: mayVSplit ? Math.floor(winWidth / 2) : winWidth,
          previewHeight: winHeight,
        } as Partial<FilerParams>,
      },
    });
    return Promise.resolve();
  }
}
