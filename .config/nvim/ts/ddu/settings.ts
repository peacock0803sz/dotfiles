import { Denops, FfParams, FilerParams, opt } from "./deps.ts";

type UiParams = Partial<FfParams | FilerParams>;

async function getSettings(denops: Denops): Promise<UiParams> {
  const winCol = await opt.columns.get(denops);
  const winRow = await opt.lines.get(denops);
  const winWidth = Math.floor(winCol * 0.95);
  const winHeight = Math.floor(winRow * 0.95);

  const mayVSplit = winCol >= 140; // 縦分割の上限列数

  return {
    split: "tab",
    floatingBorder: "single",
    prompt: ">",
    autoAction: { name: "preview", delay: 1 },
    startAutoAction: true,
    previewFloatingBorder: "single",
    previewSplit: mayVSplit ? "vertical" : "horizontal",
    winHeight: mayVSplit ? winHeight : Math.floor(winHeight / 1.75),
    winWidth: winWidth,
    previewWidth: mayVSplit ? Math.floor(winWidth / 1.75) : winWidth,
    previewHeight: mayVSplit ? winHeight : Math.floor(winHeight / 1.75),
    exprParams: [
      "previewHeight",
      "previewWidth",
      "previewCol",
      "previewRow",
      "winHeight",
      "winWidth",
      "winCol",
      "winRow",
    ],
  } satisfies UiParams;
}

export default getSettings;
