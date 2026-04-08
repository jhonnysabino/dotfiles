#!/bin/bash

set -e

FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="JetBrainsMono"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"

mkdir -p "$FONT_DIR"

if ls "$FONT_DIR"/JetBrainsMonoNerdFontMono-* >/dev/null 2>&1; then
    echo "Nerd Fonts já instaladas."
    exit 0
fi

echo "Baixando JetBrains Mono Nerd Font..."
cd /tmp
curl -fLo "${FONT_NAME}.zip" --remote-name-all "$FONT_URL"

echo "Extraindo apenas fontes Mono..."
unzip -j -o "${FONT_NAME}.zip" "JetBrainsMonoNerdFontMono-*" -d "$FONT_DIR"

rm -f "${FONT_NAME}.zip"

echo "Atualizando cache de fontes..."
fc-cache -f -v >/dev/null 2>&1 || true

echo "Nerd Fonts instaladas com sucesso!"
