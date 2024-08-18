import { BaseConfig, ConfigArguments, FilerParams } from "../deps.ts";

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
          converters: ["converter_hl_dir", "converter_devicon"],
          matchers: ["matcher_fzf"],
          sorters: ["sorter_fzf"],
          columns: ["icon_filename"],
        },
      },
    });
    return Promise.resolve();
  }
}
