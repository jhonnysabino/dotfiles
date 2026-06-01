#!/usr/bin/env node
const { execSync } = require('child_process');

function cmd(c) {
  try { return execSync(c, { encoding: 'utf8' }).trim(); }
  catch { return null; }
}

const remote = cmd('git remote get-url origin 2>/dev/null');
if (!remote) {
  console.log(JSON.stringify({ error: 'Nenhum remote configurado. git remote add origin <url>' }));
  process.exit(1);
}

let defaultBranch = null;
for (const b of ['main', 'master']) {
  if (cmd(`git rev-parse --verify origin/${b} 2>/dev/null`)) {
    defaultBranch = b;
    break;
  }
}
if (!defaultBranch) {
  console.log(JSON.stringify({ error: 'Nao foi possivel detectar branch default (origin/main ou origin/master).' }));
  process.exit(1);
}

const currentBranch = cmd('git rev-parse --abbrev-ref HEAD');
if (currentBranch === defaultBranch) {
  console.log(JSON.stringify({
    currentBranch,
    defaultBranch,
    commits: [],
    note: 'Voce esta na branch default. Crie uma branch para fazer alteracoes e abrir PR.',
  }));
  process.exit(0);
}

const range = `origin/${defaultBranch}..HEAD`;
const rawLog = cmd(`git log --format="%H|%an|%ad|%s" --date=short ${range}`);
if (!rawLog) {
  console.log(JSON.stringify({ currentBranch, defaultBranch, commits: [], note: 'Nenhum commit nao pushado encontrado.' }));
  process.exit(0);
}

const commits = rawLog.split('\n').map(line => {
  const sep = line.indexOf('|');
  const sep2 = line.indexOf('|', sep + 1);
  const sep3 = line.indexOf('|', sep2 + 1);
  return {
    hash: line.slice(0, sep),
    author: line.slice(sep + 1, sep2),
    date: line.slice(sep2 + 1, sep3),
    message: line.slice(sep3 + 1),
  };
});

const branchFiles = (cmd(`git diff --name-only ${range}`) || '').split('\n').filter(Boolean);
const branchDiffStats = cmd(`git diff --shortstat ${range}`) || 'sem alteracoes';
const branchDiffStatLines = cmd(`git diff --stat ${range}`);
const branchDiffNumstat = cmd(`git diff --numstat ${range}`) || '';

const result = { currentBranch, defaultBranch, commits, files: branchFiles, diffStats: branchDiffStats, diffStatLines: branchDiffStatLines };
console.log(JSON.stringify(result, null, 2));
