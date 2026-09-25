/**
 * pi 用 status line。組み込みフッターを置き換えて1行表示する。
 * /statusline で組み込みフッターとの切り替え可。
 */
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import type { TUI } from "@earendil-works/pi-tui";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

function fmtCount(n: number): string {
  return n < 1000 ? `${n}` : `${(n / 1000).toFixed(1)}k`;
}

interface AssistantUsage {
  input?: number;
  output?: number;
  cost?: { total?: number };
}

interface StatusData {
  model: string;
  thinking: string;
  input: number;
  output: number;
  cost: number;
  ctxText: string;
}

let data: StatusData = {
  model: "no-model",
  thinking: "",
  input: 0,
  output: 0,
  cost: 0,
  ctxText: "ctx ?",
};
let customEnabled = true;
let activeTui: TUI | undefined;

function collect(pi: ExtensionAPI, ctx: ExtensionContext): StatusData {
  let input = 0;
  let output = 0;
  let cost = 0;
  for (const entry of ctx.sessionManager.getBranch()) {
    if (entry.type !== "message") continue;
    const message = (entry as unknown as { message?: { role?: string; usage?: AssistantUsage } })
      .message;
    if (message?.role !== "assistant" || !message.usage) continue;
    input += message.usage.input ?? 0;
    output += message.usage.output ?? 0;
    cost += message.usage.cost?.total ?? 0;
  }
  const usage = ctx.getContextUsage();
  const windowSize = usage?.contextWindow ?? ctx.model?.contextWindow;
  const ctxText =
    windowSize && usage && usage.percent !== null
      ? `ctx ${Math.round(usage.percent)}%/${Math.round(windowSize / 1000)}k`
      : windowSize
        ? `ctx ?/${Math.round(windowSize / 1000)}k`
        : "ctx ?";
  return {
    model: ctx.model ? `${ctx.model.provider}/${ctx.model.id}` : "no-model",
    thinking: pi.getThinkingLevel(),
    input,
    output,
    cost,
    ctxText,
  };
}

function installFooter(ctx: ExtensionContext): void {
  ctx.ui.setFooter((tui, theme) => {
    activeTui = tui;
    return {
      dispose: () => {
        if (activeTui === tui) activeTui = undefined;
      },
      invalidate() {},
      render(width: number): string[] {
        const left = theme.fg(
          "dim",
          `↑${fmtCount(data.input)} ↓${fmtCount(data.output)} $${data.cost.toFixed(3)} | ${data.ctxText}`,
        );
        const right = theme.fg("accent", `${data.model} · ${data.thinking}`);
        const gap = " ".repeat(Math.max(1, width - visibleWidth(left) - visibleWidth(right)));
        return [truncateToWidth(left + gap + right, width)];
      },
    };
  });
}

function refresh(pi: ExtensionAPI, ctx: ExtensionContext): void {
  if (!ctx.hasUI) return;
  data = collect(pi, ctx);
  activeTui?.requestRender();
}

export default function (pi: ExtensionAPI): void {
  pi.on("session_start", async (_event, ctx) => {
    if (!ctx.hasUI) return;
    data = collect(pi, ctx);
    if (customEnabled) installFooter(ctx);
  });
  pi.on("turn_end", async (_event, ctx) => {
    refresh(pi, ctx);
  });
  pi.on("agent_end", async (_event, ctx) => {
    refresh(pi, ctx);
  });
  pi.on("agent_settled", async (_event, ctx) => {
    refresh(pi, ctx);
  });
  pi.on("model_select", async (_event, ctx) => {
    refresh(pi, ctx);
  });
  pi.on("thinking_level_select", async (_event, ctx) => {
    refresh(pi, ctx);
  });
  pi.on("session_compact", async (_event, ctx) => {
    refresh(pi, ctx);
  });
  pi.on("session_shutdown", async (_event, ctx) => {
    ctx.ui.setFooter(undefined);
  });

  pi.registerCommand("statusline", {
    description: "組み込みフッターと statusline 表示を切り替える",
    handler: async (_args, ctx) => {
      customEnabled = !customEnabled;
      if (customEnabled) {
        data = collect(pi, ctx);
        installFooter(ctx);
      } else {
        ctx.ui.setFooter(undefined);
      }
    },
  });
}
