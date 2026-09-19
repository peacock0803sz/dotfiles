import { BaseConfig, type ConfigArguments } from "@shougo/ddu-vim/config";
import { type Params as FfParams } from "@shougo/ddu-ui-ff";
import getSettings from "#settings";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "ff",
      uiParams: {
        ff: {
          displayTree: true,
          ...(await getSettings(args.denops)),
        } as FfParams,
      },
    });
    return Promise.resolve();
  }
}
