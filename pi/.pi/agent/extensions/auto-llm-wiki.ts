import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { readFileSync } from "node:fs";

const WIKI_SKILL_PATH = "/home/jhonny-sabino/.pi/agent/skills/llm-wiki/SKILL.md";
const WIKI_MARKER = "## LLM-WIKI INJECTED";

export default function (pi: ExtensionAPI) {
  let wikiContent: string;

  try {
    const raw = readFileSync(WIKI_SKILL_PATH, "utf-8");
    wikiContent = raw.replace(/^---\n[\s\S]*?\n---\n*/, "").trim();
  } catch {
    console.error("[auto-llm-wiki] FAIL: cannot read llm-wiki SKILL.md");
    return;
  }

  pi.on("before_agent_start", async (event, _ctx) => {
    const alreadyInjected = event.systemPrompt?.includes(WIKI_MARKER);
    if (alreadyInjected) return;

    const injection = `${WIKI_MARKER}\n\n${wikiContent}\n\n${WIKI_MARKER}`;

    return {
      systemPrompt: event.systemPrompt + "\n\n" + injection,
    };
  });
}
