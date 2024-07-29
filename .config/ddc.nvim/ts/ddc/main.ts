import { BaseConfig, ConfigArguments } from "./deps.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments) {
    args.contextBuilder.patchGlobal({
      ui: "pum",
      autoCompleteEvents: ["InsertEnter", "TextChangedI", "TextChangedP"],
      sources: ["around"],
      sourceOptions: {
        _: {
          converters: ["converter_fuzzy"],
          matchers: ["matcher_fuzzy"],
          sorters: ["sorter_fuzzy"],
          minAutoCompleteLength: 2,
        },
      },
    });
    return Promise.resolve();
  }
}
