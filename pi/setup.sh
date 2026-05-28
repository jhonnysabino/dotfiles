#!/usr/bin/env bash
set -euo pipefail

echo "=== Setup PI em nova máquina ==="

# 1. Stow (assume que ~/dotfiles existe e foi clonado)
cd ~/dotfiles
stow pi 2>/dev/null || stow --no-folding pi
echo "✓ Config stowed"

# 2. Instalar pi (se não existir)
if ! command -v pi &>/dev/null; then
  echo "Instalando pi..."
  npm install -g --ignore-scripts @earendil-works/pi-coding-agent
fi

# 3. Re-instalar packages do settings.json
echo "Instalando packages..."
pi install npm:@codexstar/pi-listen
pi install npm:@aliou/pi-processes

# 4. Autenticar
echo ""
echo "=================================="
echo "  Rode 'pi' e faca /login"
echo "  Ou export ANTHROPIC_API_KEY=..."
echo "=================================="
