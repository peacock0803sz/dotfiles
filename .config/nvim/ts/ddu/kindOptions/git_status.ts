import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
  ConfigArguments,
  stdpath,
  u,
} from "../deps.ts";

type GitStatusActionData = {
  status: string;
  path: string;
  worktree: string;
};

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      kindOptions: {
        git_status: {
          defaultAction: "open",
          actions: {
            commit: async () => {
              await args.denops.call("Gin commit");
              return ActionFlags.None;
            },
            diff: async (args: ActionArguments<Record<string, unknown>>) => {
              const action = args.items[0].action as GitStatusActionData;
              const path = stdpath.join(action.worktree, action.path);
              await args.denops.call("ddu#start", {
                name: "file:git_diff",
                sources: [
                  {
                    name: "git_diff",
                    options: {
                      path,
                    },
                    params: {
                      ...(u.maybe(args.actionParams, u.isRecord) ?? {}),
                      onlyFile: true,
                    },
                  },
                ],
              });
              return ActionFlags.None;
            },
            // fire GinPatch command to selected items
            // using https://github.com/lambdalisue/gin.vim
            patch: async (args: ActionArguments<Record<never, never>>) => {
              for (const item of args.items) {
                const action = item.action as GitStatusActionData;
                await args.denops.cmd("tabnew");
                await args.denops.cmd("tcd " + action.worktree);
                await args.denops.cmd("GinPatch ++no-head " + action.path);
              }
              return ActionFlags.None;
            },
          },
        },
      },
    });

    return Promise.resolve();
  }
}
