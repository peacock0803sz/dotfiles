import { BaseConfig } from "https://deno.land/x/ddu_vim@v3.10.0/types.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.10.0/base/config.ts";
import { Params as FfParams } from "https://deno.land/x/ddu_ui_ff@v1.1.0/ff.ts";

import getSettings from "../settings.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "ff",
      uiParams: { ff: (await getSettings(args.denops)) as FfParams },
    });
    return Promise.resolve();
  }
}
