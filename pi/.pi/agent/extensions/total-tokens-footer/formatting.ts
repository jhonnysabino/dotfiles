/**
 * Pure formatting functions for total-tokens-footer.
 *
 * Taxonomy:
 *   Calculations (calc_*) — pure, same input → same output
 *   Data helpers — hex validation regex
 */

import type { TotalTokensConfig } from "./config";

// ===== Calculations (calc_*) =====

/**
 * Maps a token count to its tier color based on config thresholds.
 *
 * Three tiers (traffic-light):
 *   tokens < tier1Threshold → tier1Color
 *   tier1Threshold ≤ tokens < tier2Threshold → tier2Color
 *   tokens ≥ tier2Threshold → tier3Color
 *
 * Pure: same (tokens, config) → same hex string.
 */
export function calc_getTokenColor(
  tokens: number,
  config: TotalTokensConfig,
): string {
  if (tokens >= config.tier2Threshold) return config.tier3Color;
  if (tokens >= config.tier1Threshold) return config.tier2Color;
  return config.tier1Color;
}

/**
 * Formats a token count into a human-readable short string.
 *
 * Pure: same count → same string.
 * No I/O, no globals, no side effects.
 *
 * Examples:
 *   500     → "500"
 *   1500    → "1.5K"
 *   100000  → "100K"
 *   123400  → "123.4K"
 */
export function calc_formatTokenCount(count: number): string {
  if (count < 1000) return `${count}`;

  const k = count / 1000;

  // Above 100K → integer K (e.g. "123K")
  if (count >= 100000) {
    const rounded = Math.round(k);
    return rounded >= 100 ? `${rounded}K` : `${k.toFixed(1)}K`;
  }

  // Below 100K → one decimal (e.g. "12.3K", "1.5K")
  return `${k.toFixed(1)}K`;
}

// ===== Data Helpers (pure) =====

/**
 * Regex for valid 24-bit truecolor hex strings (e.g. "#ff4444", "#00ff88").
 */
const HEX_COLOR_RE = /^#[0-9a-fA-F]{6}$/;

/**
 * Wraps text in a 24-bit truecolor ANSI escape sequence.
 *
 * Pure: same (text, hex) → same ANSI-wrapped string.
 * Returns original text unchanged if hex is invalid.
 */
export function colorHex(text: string, hex: string): string {
  if (!HEX_COLOR_RE.test(hex)) return text;

  const r = parseInt(hex.slice(1, 3), 16);
  const g = parseInt(hex.slice(3, 5), 16);
  const b = parseInt(hex.slice(5, 7), 16);

  return `\x1b[38;2;${r};${g};${b}m${text}\x1b[0m`;
}
