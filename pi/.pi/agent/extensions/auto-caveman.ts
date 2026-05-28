import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { readFileSync } from "node:fs";

const CAVEMAN_SKILL_PATH = "/home/jhonny-sabino/.pi/agent/skills/caveman/SKILL.md";
const CAVEMAN_MARKER = "## CAVEMAN MODE ACTIVE";

export default function (pi: ExtensionAPI) {
  let cavemanContent: string;
  let enabled = true;

  try {
    const raw = readFileSync(CAVEMAN_SKILL_PATH, "utf-8");
    cavemanContent = raw.replace(/^---\n[\s\S]*?\n---\n*/, "").trim();
  } catch {
    console.error("[auto-caveman] FAIL: cannot read caveman SKILL.md");
    return;
  }

  pi.on("before_agent_start", async (event, _ctx) => {
    const prompt = event.prompt?.toLowerCase() ?? "";

    if (prompt.includes("stop caveman") || prompt.includes("normal mode")) {
      enabled = false;
    }

    if (!enabled) return;

    const alreadyInjected = event.systemPrompt?.includes(CAVEMAN_MARKER);
    if (alreadyInjected) return;

    const injection = `${CAVEMAN_MARKER}\n\n${cavemanContent}\n\n${CAVEMAN_MARKER}`;

    return {
      systemPrompt: event.systemPrompt + "\n\n" + injection,
    };
  });
}
