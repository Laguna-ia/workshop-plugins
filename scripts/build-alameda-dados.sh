#!/usr/bin/env bash
# Monta os zips do plugin alameda-dados nas três versões do workshop a partir do pacote do Leo:
#   1.0.0  as 6 skills do estado inicial
#   1.1.0  + produtividade-por-m2          (plano B do fim do Módulo 1)
#   1.2.0  + relatorio-semanal-regional    (plano B do fim do Módulo 2)
# Uso: scripts/build-alameda-dados.sh [PACOTE]      (PACOTE = pasta com skills/; padrão: $ALAMEDA_PACOTE ou ./pacote)
#      scripts/build-alameda-dados.sh --sem-skills   (só confere/monta o 1.0.0 vazio, igual ao que está em plugins/)
# Layout aceito em PACOTE/skills/:
#   (a) plano:        skills/<nome>/SKILL.md para as 8 skills (cada versão usa o seu subconjunto, abaixo); ou
#   (b) por versão:   skills/1.0/<nome>/SKILL.md, skills/1.1/..., skills/1.2/... (cada pasta é o conjunto COMPLETO da versão).
# O texto das skills é copiado byte a byte; nada é escrito nem editado aqui. Saída: dist/alameda-dados-<versão>.zip, no mesmo
# layout de build-zips.sh (pasta alameda-dados/ na raiz, sem arquivos ocultos), com datas fixas para o zip ser reproduzível.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME=alameda-dados
V10=(venda-liquida lfl curva-abc sell-through cobertura-estoque ruptura)
V11=("${V10[@]}" produtividade-por-m2)
V12=("${V11[@]}" relatorio-semanal-regional)
SEM=0; PACOTE="${ALAMEDA_PACOTE:-$ROOT/pacote}"
case "${1:-}" in --sem-skills) SEM=1 ;; "") ;; *) PACOTE="$1" ;; esac
DIST="$ROOT/dist"; mkdir -p "$DIST"
STAGE="$(mktemp -d)"; trap 'rm -rf "$STAGE"' EXIT

montar() { # versão semver, lista de skills
  local ver="$1"; shift
  local short="${ver%.0}"; local dir="$STAGE/$ver/$NAME"
  mkdir -p "$STAGE/$ver"
  cp -R "$ROOT/plugins/$NAME" "$dir"
  rm -f "$dir/skills/.gitkeep"; mkdir -p "$dir/skills"
  if [ "$SEM" = 0 ]; then
    local fonte
    if [ -d "$PACOTE/skills/$short" ]; then fonte="$PACOTE/skills/$short"; else fonte="$PACOTE/skills"; fi
    for s in "$@"; do
      [ -f "$fonte/$s/SKILL.md" ] || { echo "ERRO: falta $fonte/$s/SKILL.md (versão $ver)" >&2; exit 1; }
      mkdir -p "$dir/skills/$s"; cp -R "$fonte/$s/." "$dir/skills/$s/"
    done
  fi
  python3 - "$dir" "$ver" <<'PY'
import json, sys
d, v = sys.argv[1:3]
for p in (f"{d}/plugin.json", f"{d}/.claude-plugin/plugin.json"):
    j = json.load(open(p, encoding="utf-8")); j["version"] = v
    open(p, "w", encoding="utf-8").write(json.dumps(j, ensure_ascii=False, indent=2) + "\n")
PY
  find "$STAGE/$ver" -exec touch -t 202610290000 {} +
  rm -f "$DIST/$NAME-$short.zip"
  ( cd "$STAGE/$ver" && find "$NAME" -type f ! -name '.*' ! -path '*/.*' | LC_ALL=C sort | zip -q -X "$DIST/$NAME-$short.zip" -@ )
  echo "dist/$NAME-$short.zip  ($ver, $(find "$dir/skills" -name SKILL.md | wc -l | tr -d " ") skills)"
  unzip -Z1 "$DIST/$NAME-$short.zip" | sed 's/^/  /'
}

montar 1.0.0 "${V10[@]}"
montar 1.1.0 "${V11[@]}"
montar 1.2.0 "${V12[@]}"
