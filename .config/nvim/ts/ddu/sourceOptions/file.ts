import {
  ActionArguments,
  ActionData,
  ActionFlags,
  BaseConfig,
  ConfigArguments,
  fn,
} from "../deps.ts";

type Params = Record<string, unknown>;

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      kindOptions: {
        file: {
          defaultAction: "open",
          actions: {
            grep: async (args: ActionArguments<Params>) => {
              const action = args.items[0]?.action as ActionData;

              await args.denops.call("ddu#start", {
                name: args.options.name,
                push: true,
                sources: [
                  {
                    name: "rg",
                    options: {
                      machers: [],
                      volatile: true,
                    },
                    params: {
                      path: action.path,
                      input: await fn.input(args.denops, "Pattern: "),
                    },
                  },
                ],
              });

              return Promise.resolve(ActionFlags.None);
            },

            uiCd: async (args: ActionArguments<Params>) => {
              const action = args.items[0]?.action as ActionData;

              await args.denops.call("ddu#ui#do_action", {
                name: "narrow",
                params: {
                  path: action.path,
                },
              });

              return Promise.resolve(ActionFlags.None);
            },
          },
        },
      },
    });

    return Promise.resolve();
  }
}
