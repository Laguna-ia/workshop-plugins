#!/usr/bin/env bash
# Gera dist/<plugin>.zip para cada pasta em plugins/, no mesmo layout dos zips
# publicados em lagunaai.org: uma pasta <plugin>/ na raiz do zip, sem arquivos
# ocultos (.claude-plugin/, .DS_Store etc.).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST="$ROOT/dist"
rm -rf "$DIST"
mkdir -p "$DIST"
cd "$ROOT/plugins"
for dir in */; do
  name="${dir%/}"
  zip -q -r -X "$DIST/$name.zip" "$name" -x '*/.*' -x '.*'
  echo "dist/$name.zip"
  unzip -Z1 "$DIST/$name.zip" | sed 's/^/  /'
done
