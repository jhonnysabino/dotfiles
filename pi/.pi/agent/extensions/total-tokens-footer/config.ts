/**
 * Configuration system for total-tokens-footer.
 *
 * Taxonomy:
 *   Data — Config interface, defaults, STATUS_KEY
 *   Actions (I/O) — readFullSettings, writeFullSettings
 *   Orchestration — readConfig, writeConfig
 *   Calculations — calc_isValidThresholdOrder (pure)
 */

import { getAgentDir } from "@earendil-works/pi-coding-agent";
import { readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

// ===== Data =====

/** Key used in settings.json for config persistence */
export const SETTINGS_KEY = "totalTokens";

/**
 * Status bar entry key — "0_" prefix sorts first so this extension
 * always appears leftmost in the footer.
 */
export const STATUS_KEY = "0_tokens";

/** Display mode for token count */
export type DisplayMode = "short" | "full";

/**
 * Color tier configuration.
 *
 * Three tiers produce a traffic-light system:
 *   tokens < tier1Threshold  → tier1Color (green)
 *   tier1Threshold ≤ tokens < tier2Threshold → tier2Color (yellow)
 *   tokens ≥ tier2Threshold → tier3Color (red)
 */
export interface TotalTokensConfig {
  display: DisplayMode;

  /** Tokens below this threshold get tier1Color (default: 70K) */
  tier1Threshold: number;
  /** Color for moderate usage (default: green #00ff88) */
  tier1Color: string;

  /** Tokens above this threshold get tier2Color (default: 100K) */
  tier2Threshold: number;
  /** Color for high usage (default: yellow #ffaa00) */
  tier2Color: string;

  /** Color for critical usage above tier2Threshold (default: red #ff4444) */
  tier3Color: string;
}

/** Built-in defaults (overridable via settings.json ["totalTokens"]) */
const DEFAULT_CONFIG: TotalTokensConfig = {
  display: "short",

  tier1Threshold: 70000,
  tier1Color: "#00ff88",

  tier2Threshold: 100000,
  tier2Color: "#ffaa00",

  tier3Color: "#ff4444",
};

// Write-through cache — prevents repeated filesystem reads
let cachedConfig: TotalTokensConfig | null = null;

// ===== Calculations (pure) =====

/**
 * Validates that tier thresholds are in ascending order.
 * Pure: same config → same boolean.
 */
export function calc_isValidThresholdOrder(config: TotalTokensConfig): boolean {
  return config.tier1Threshold < config.tier2Threshold;
}

// ===== Actions (I/O) =====

/**
 * Reads the full settings.json file.
 * Returns {} on missing or unparseable file (never throws).
 */
function readFullSettings(): Record<string, unknown> {
  try {
    const settingsPath = join(getAgentDir(), "settings.json");
    const raw = readFileSync(settingsPath, "utf-8");
    return JSON.parse(raw) as Record<string, unknown>;
  } catch {
    return {};
  }
}

/**
 * Writes the full settings object back to settings.json.
 */
function writeFullSettings(settings: Record<string, unknown>): void {
  const settingsPath = join(getAgentDir(), "settings.json");
  writeFileSync(settingsPath, JSON.stringify(settings, null, 2), "utf-8");
}

// ===== Orchestration =====

/**
 * Returns the resolved config: defaults merged with user overrides.
 * Cached after first read — call resetConfigCache() to force re-read.
 *
 * Validates threshold order on merge. Falls back to defaults if invalid.
 */
export function readConfig(): TotalTokensConfig {
  if (cachedConfig) return cachedConfig;

  const settings = readFullSettings();
  const userConfig = (settings[SETTINGS_KEY] ?? {}) as Partial<TotalTokensConfig>;

  const merged: TotalTokensConfig = {
    ...DEFAULT_CONFIG,
    ...userConfig,
    display: userConfig.display === "full" ? "full" : "short",
  };

  // Validate threshold order — fall back to defaults if misconfigured
  if (!calc_isValidThresholdOrder(merged)) {
    merged.tier1Threshold = DEFAULT_CONFIG.tier1Threshold;
    merged.tier2Threshold = DEFAULT_CONFIG.tier2Threshold;
  }

  cachedConfig = merged;
  return merged;
}

/**
 * Merges a partial config into settings.json under ["totalTokens"].
 * Invalidates the cache so next readConfig() picks up changes.
 */
export function writeConfig(partial: Partial<TotalTokensConfig>): void {
  const settings = readFullSettings();
  const current = (settings[SETTINGS_KEY] as Record<string, unknown>) ?? {};
  settings[SETTINGS_KEY] = { ...current, ...partial };
  writeFullSettings(settings);
  cachedConfig = null;
}

/**
 * Forces re-read from disk on next readConfig() call.
 */
export function resetConfigCache(): void {
  cachedConfig = null;
}
