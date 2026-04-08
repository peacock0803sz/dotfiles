import { BaseConfig, type ConfigArguments } from "@shougo/ddu-vim/config";
import { type Params as FilerParams } from "@shougo/ddu-ui-filer";
import getSettings from "#settings";

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
          sorters: ["sorter_alpha"],
          converters: ["converter_hl_dir"],
          columns: ["filename"],
        },
      },
    });
    return Promise.resolve();
  }
}
