import { BaseConfig } from "https://deno.land/x/ddu_vim@v3.10.2/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.10.2/base/config.ts";
import { Params as FilerParams } from "https://deno.land/x/ddu_ui_filer@v1.1.0/filer.ts";

import getSettings from "../settings.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "ff",
      uiOptions: {
        filer: {
          toggle: true,
        },
      },
      uiParams: {
        filer: (await getSettings(args.denops)) as FilerParams,
      },
      sourceOptions: {
        file: {
          converters: ["converter_hl_dir"],
          columns: ["icon_filename"],
        },
      },
    });
    return Promise.resolve();
  }
}
