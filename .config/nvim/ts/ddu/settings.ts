import { Denops } from "https://deno.land/x/denops_std@v5.3.0/mod.ts";
import * as opt from "https://deno.land/x/denops_std@v5.3.0/option/mod.ts";

import { Params as FfParams } from "https://deno.land/x/ddu_ui_ff@v1.1.0/ff.ts";
import { Params as FilerParams } from "https://deno.land/x/ddu_ui_filer@v1.1.0/filer.ts";

type UiParams = Partial<FfParams | FilerParams>;

async function getSettings(denops: Denops): Promise<UiParams> {
  const winCol = await opt.columns.get(denops);
  const winRow = await opt.lines.get(denops);
  const winWidth = Math.floor(winCol * 0.95);
  const winHeight = Math.floor(winRow * 0.8);

  const mayVSplit = winCol >= 50; // 縦分割の上限列数

  return {
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
    winWidth: winWidth,
    winRow: 3,
    winCol: 5,
    previewWidth: mayVSplit ? Math.floor(winWidth / 2) : winWidth,
    previewHeight: mayVSplit ? winHeight : Math.floor(winHeight / 1.5),
  } satisfies UiParams;
}

export default getSettings;
