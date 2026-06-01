import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  // ── Tool call loop detection ──────────────────────────────────
  const toolHistory: string[] = [];
  const LOOP_THRESHOLD = 6;
  const WINDOW_SIZE = 10;

  pi.on("tool_call", async (event, ctx) => {
    const sig = `${event.toolName}:${JSON.stringify(event.input)}`;
    toolHistory.push(sig);
    while (toolHistory.length > WINDOW_SIZE) toolHistory.shift();

    const recent = toolHistory.slice(-LOOP_THRESHOLD);
    if (
      recent.length === LOOP_THRESHOLD &&
      new Set(recent).size === 1 &&
      event.toolName !== "read"
    ) {
      ctx.ui.notify(
        "⚠️ Loop detectado — mesma ferramenta/chamada repetida. Repensando...",
        "warning",
      );
    }
  });

  // ── Stuck detection: reasoning sem text ──────────────────────
  pi.on("message_end", async (event, ctx) => {
    const msg = event.message;
    if (msg.role !== "assistant") return;

    const content = msg.content ?? [];
    const hasThinking = content.some((c) => c.type === "thinking");
    const hasText = content.some((c) => c.type === "text");
    const stopReason = msg.stopReason ?? msg.stop_reason;

    // Só ativa quando: thinking presente, text ausente, stop=stop
    if (hasThinking && !hasText && stopReason === "stop") {
      const thinkingText = content
        .filter((c) => c.type === "thinking")
        .map((c) => c.thinking ?? "")
        .join("\n");

      ctx.ui.notify("⚠️ Modelo travou — resposta extraída do reasoning", "warning");

      return {
        message: {
          ...msg,
          content: [
            ...content,
            { type: "text", text: thinkingText },
          ],
        },
      };
    }
  });
}
