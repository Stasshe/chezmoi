#!/usr/bin/env node
// SessionStart hook: shrink the per-turn additionalContext reminders emitted
// by the caveman/genshijin mode-tracker UserPromptSubmit hooks. Both plugins
// inject their full ruleset once at SessionStart; the per-turn reminder only
// needs to be a tiny attention anchor, not ~285 tokens on every message.
//
// Re-runs every session, so it survives plugin updates (which replace the
// plugin cache directory and would otherwise revert a one-off patch).
// Idempotent: only rewrites when the matched expression is still long.
// Fail-safe: if a future plugin version changes the code shape, the regex
// simply won't match and the file is left untouched.
// Must stay silent on stdout — SessionStart stdout is injected as context.
const fs = require('fs');
const path = require('path');
const os = require('os');

const claudeDir = process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude');

const TARGETS = [
  {
    root: path.join(claudeDir, 'plugins', 'cache', 'genshijin'),
    file: 'genshijin-mode-tracker.js',
    short: '"原始人モード有効。SessionStartのgenshijinルール全て維持。"',
  },
  {
    root: path.join(claudeDir, 'plugins', 'cache', 'caveman'),
    file: 'caveman-mode-tracker.js',
    short: '"CAVEMAN MODE ACTIVE. Keep SessionStart caveman rules."',
  },
];

// Matches `additionalContext: "..." + ident + "..." ...` concat chains.
const EXPR = /additionalContext:\s*"(?:[^"\\]|\\.)*"(?:\s*\+\s*(?:[A-Za-z_$][\w$.]*|"(?:[^"\\]|\\.)*"))*/g;
const MIN_LEN = 120; // shorter matches are already-patched or harmless

function findFiles(dir, name, out) {
  let entries;
  try { entries = fs.readdirSync(dir, { withFileTypes: true }); } catch (e) { return; }
  for (const e of entries) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) findFiles(p, name, out);
    else if (e.isFile() && e.name === name) out.push(p);
  }
}

for (const t of TARGETS) {
  const files = [];
  findFiles(t.root, t.file, files);
  for (const f of files) {
    try {
      const src = fs.readFileSync(f, 'utf8');
      const patched = src.replace(EXPR, m =>
        m.length > MIN_LEN ? 'additionalContext: ' + t.short : m);
      if (patched !== src) fs.writeFileSync(f, patched);
    } catch (e) { /* never block session start */ }
  }
}
