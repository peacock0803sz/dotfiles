/**
 * Claude Code の Notification hook 相当。応答が完了して入力待ちになったら通知する。
 * tmux では client tty へ書き込む必要があり、その分岐を既存の notify スクリプトが
 * 持っているため、OSC 777 を直接吐かずスクリプトを再利用する。
 */
import { execFile } from "node:child_process";
import { homedir } from "node:os";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const notifyScript = `${homedir()}/dotfiles/dot_config/agents/scripts/notify`;

export default function (pi: ExtensionAPI) {
	// agent_end 後もリトライや queued follow-up で動き続けることがあるため
	// agent_settled まで待って通知する
	pi.on("agent_settled", async () => {
		execFile(notifyScript, ["pi", "Waiting for input"], () => {});
	});
}
