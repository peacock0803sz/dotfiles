/**
 * Claude Code の permissions.deny を pi で再現する拡張。
 * pi は確認プロンプトなしでツールを即実行するため、危険なコマンドと
 * ユーザーに実行を委ねる運用のコマンドを tool_call の段階で拒否する。
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

interface DenyRule {
	pattern: RegExp;
	reason: string;
}

const ASK_USER = "ユーザーに実行を依頼すること";

const denyRules: DenyRule[] = [
	{ pattern: /^rm\s+-rf\s+\//, reason: "破壊的コマンド" },
	{ pattern: /^sudo\b/, reason: ASK_USER },
	{ pattern: /^chmod\b/, reason: ASK_USER },
	{ pattern: /^dd\s+if=/, reason: "破壊的コマンド" },
	{ pattern: /^mkfs\./, reason: "破壊的コマンド" },
	{ pattern: /^(fdisk|format|shutdown|reboot|halt|poweroff)\b/, reason: "破壊的コマンド" },
	{ pattern: /^(killall|pkill)\b/, reason: ASK_USER },
	{ pattern: /^(nc|ncat|netcat)\s+-l\b/, reason: "リッスン系コマンドは実行しない" },
	{ pattern: /^(docker|gcloud|kubectl)\b/, reason: "MCP サーバー経由で実行すること" },
	{ pattern: /^git\s+-C\b/, reason: "git -C は使わず対象リポジトリ内で実行すること" },
	{ pattern: /^git\s+add\s+\.\s*$/, reason: "git add . は使わずファイルを明示すること" },
	{ pattern: /^git\s+push\b/, reason: ASK_USER },
	{
		pattern: /^git\s+status\s+--untracked-files=no\b/,
		reason: "untracked を隠す git status は使わない",
	},
	{
		pattern: /^(\.venv\/bin\/)?python/,
		reason: "Python 直接実行は不可。.venv/bin の ruff/ty/pytest か python3 -m doctest を使うこと",
	},
	{ pattern: /^uv\s+run\b/, reason: ASK_USER },
];

// deny に一致しても許可する例外 (Claude Code の allow リスト由来)
const allowPatterns: RegExp[] = [/^\.venv\/bin\/python3?\s+-m\s+doctest\b/];

// 複合コマンド (cd x && python ...) の各セグメント先頭で判定する。
// 引用符内の区切り文字までは解析しない (Claude Code のマッチャも同程度の精度)
function segments(command: string): string[] {
	return command
		.split(/(?:&&|\|\||[;|&\n])/)
		.map((s) => s.trim())
		.filter((s) => s.length > 0);
}

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event) => {
		if (event.toolName !== "bash") return undefined;

		const command = (event.input as { command?: unknown }).command;
		if (typeof command !== "string") return undefined;

		for (const seg of segments(command)) {
			if (allowPatterns.some((p) => p.test(seg))) continue;
			const hit = denyRules.find((r) => r.pattern.test(seg));
			if (hit) {
				return {
					block: true,
					reason: `permission-gate: \`${seg}\` は実行不可 (${hit.reason})`,
				};
			}
		}
		return undefined;
	});
}
