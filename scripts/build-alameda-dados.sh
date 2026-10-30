#!/usr/bin/env bash
# Monta os zips do plugin alameda-dados nas três versões do workshop a partir do pacote do Leo. As versões são ACUMULATIVAS:
#   1.0.0  = skills/1.0                         (as 6 skills do estado inicial; é o que já está em plugins/alameda-dados/skills)
#   1.1.0  = 1.0 + skills/1.1                   (+ produtividade-por-m2, plano B do fim do Módulo 1)
#   1.2.0  = 1.1 + skills/1.2                   (+ relatorio-semanal-regional, plano B do fim do Módulo 2)
# Uso: scripts/build-alameda-dados.sh [PACOTE]      (PACOTE = pasta com skills/; padrão: $ALAMEDA_PACOTE ou ./pacote)
#      scripts/build-alameda-dados.sh --sem-skills   (não lê o pacote: monta só o 1.0.0 com as skills que já estão em plugins/)
# Layout esperado em PACOTE/skills/ (cada pasta traz SÓ as skills que a versão ACRESCENTA, não o conjunto completo):
#   skills/1.0/<nome>/SKILL.md, skills/1.1/<nome>/SKILL.md, skills/1.2/<nome>/SKILL.md
# O 1.0.0 parte de plugins/alameda-dados/skills (a versão do marketplace) e sobrepõe skills/1.0 do pacote, que deve ser idêntica.
# O texto das skills é copiado byte a byte; nada é escrito nem editado aqui. Saída: dist/alameda-dados-<versão>.zip, no mesmo
# layout de build-zips.sh (pasta alameda-dados/ na raiz, sem arquivos ocultos), com datas fixas para o zip ser reproduzível.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME=alameda-dados
SEM=0; PACOTE="${ALAMEDA_PACOTE:-$ROOT/pacote}"
case "${1:-}" in --sem-skills) SEM=1 ;; "") ;; *) PACOTE="$1" ;; esac
DIST="$ROOT/dist"; mkdir -p "$DIST"
STAGE="$(mktemp -d)"; trap 'rm -rf "$STAGE"' EXIT

montar() { # versão semver, pastas do pacote a acumular (ex.: 1.0 1.1)
  local ver="$1"; shift
  local short="${ver%.0}"; local dir="$STAGE/$ver/$NAME"
  mkdir -p "$STAGE/$ver"
  cp -R "$ROOT/plugins/$NAME" "$dir"
  rm -f "$dir/skills/.gitkeep"; mkdir -p "$dir/skills"
  if [ "$SEM" = 0 ]; then
    local v fonte s
    for v in "$@"; do
      fonte="$PACOTE/skills/$v"
      [ -d "$fonte" ] || { echo "ERRO: falta a pasta $fonte (versão $ver)" >&2; exit 1; }
      for s in "$fonte"/*/; do
        [ -f "${s}SKILL.md" ] || { echo "ERRO: falta ${s}SKILL.md (versão $ver)" >&2; exit 1; }
        mkdir -p "$dir/skills/$(basename "$s")"; cp -R "$s." "$dir/skills/$(basename "$s")/"
      done
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

montar 1.0.0 1.0
if [ "$SEM" = 0 ]; then
  montar 1.1.0 1.0 1.1
  montar 1.2.0 1.0 1.1 1.2
fi
