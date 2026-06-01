/**
 * Total Tokens Footer — Pi extension
 *
 * Displays running token usage in the status bar with traffic-light tiers:
 *   🟩 0–70K  → green
 *   🟨 70K–100K → yellow
 *   🟥 100K+  → red
 *
 * Taxonomy:
 *   Data — config, settings key
 *   Calculations — calc_formatTokenCount, calc_getTokenColor, colorHex (in formatting.ts)
 *   Actions — action_updateStatus (I/O: getContextUsage + setStatus)
 *   Orchestration — event handlers + /total-tokens command
 */

import type {
  ExtensionAPI,
  ExtensionContext,
  ExtensionCommandContext,
} from "@earendil-works/pi-coding-agent";
import {
  readConfig,
  writeConfig,
  STATUS_KEY,
  SETTINGS_KEY,
  type TotalTokensConfig,
} from "./config";
import { calc_formatTokenCount, calc_getTokenColor, colorHex } from "./formatting";

// ===== Actions (I/O) =====

/**
 * Reads current token usage from the session context and updates the
 * status bar with a formatted, color-tiered string.
 *
 * Action: depends on ctx.getContextUsage() (I/O) and ctx.ui.setStatus() (I/O).
 */
function action_updateStatus(
  ctx: ExtensionContext,
  config: TotalTokensConfig,
): void {
  const usage = ctx.getContextUsage();
  if (!usage || usage.tokens === null || usage.tokens === undefined) return;

  const { tokens } = usage;
  const theme = ctx.ui.theme;

  // Prefix (dim label) — "[TOKENS]: ~" always shown, value colored by tier
  const prefix = theme.fg("dim", "[TOKENS]: ~");

  // Choose short ("73.0K") or full ("73.000") representation
  const rawCount =
    config.display === "full"
      ? tokens.toLocaleString("pt-BR")
      : calc_formatTokenCount(tokens);

  // Apply traffic-light color by tier
  const color = calc_getTokenColor(tokens, config);
  const countStr = colorHex(rawCount, color);

  ctx.ui.setStatus(STATUS_KEY, `${prefix}${countStr}`);
}

// ===== Extension Entry =====

export default function (pi: ExtensionAPI) {
  const update = (ctx: ExtensionContext) => {
    action_updateStatus(ctx, readConfig());
  };

  pi.on("session_start", async (_event, ctx) => {
    update(ctx);
  });

  pi.on("turn_end", async (_event, ctx) => {
    update(ctx);
  });

  pi.registerCommand("total-tokens", {
    description: "Toggle display mode between 'short' and 'full'",
    handler: async (_args: string, ctx: ExtensionCommandContext) => {
      const config = readConfig();
      const newDisplay: "short" | "full" =
        config.display === "full" ? "short" : "full";

      writeConfig({ display: newDisplay });
      action_updateStatus(ctx, readConfig());

      ctx.ui.notify(
        `[total-tokens-footer] Display mode → ${newDisplay}`,
        "info",
      );
    },
  });
}
