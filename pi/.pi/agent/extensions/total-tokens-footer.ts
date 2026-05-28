/**
 * Total Tokens Footer Status
 *
 * Adiciona "~X tokens usados" no footer do pi (via setStatus)
 * sem substituir o footer padrão. Atualiza automático a cada turno.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	const update = (ctx: any) => {
		const usage = ctx.getContextUsage();
		if (!usage || usage.tokens === null) return;

		const fmt = (n: number) =>
			n < 1000 ? `${n}` : `${(n / 1000).toFixed(1)}K`;

		ctx.ui.setStatus(
			"total-tokens",
			ctx.ui.theme.fg("accent", `~${fmt(usage.tokens)} tokens usados`),
		);
	};

	pi.on("session_start", async (_event, ctx) => {
		update(ctx);
	});

	pi.on("turn_end", async (_event, ctx) => {
		update(ctx);
	});
}
