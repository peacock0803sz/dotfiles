import { BaseConfig, ConfigArguments, FfParams } from "../deps.ts";

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
