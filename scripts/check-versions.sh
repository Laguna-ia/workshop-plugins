#!/usr/bin/env bash
# Falha se a versão de algum plugin divergir entre plugin.json (Agent Plugins /
# ChatGPT), .claude-plugin/plugin.json (Claude) e .claude-plugin/marketplace.json.
# Se TAG (ex.: v1.2.0) estiver definida, exige também que todas batam com ela.
#
# Exceção: plugins com versão própria (INDEPENDENT, hoje alameda-dados e trama-erp) precisam ter os TRÊS manifests iguais entre si,
# mas não entram na regra de versão única nem na checagem da TAG. O alameda-dados é publicado em 1.0, 1.1 e 1.2 (as versões
# do workshop; ver scripts/build-alameda-dados.sh): a versão que fica em plugins/ é a do marketplace (1.0.0). O trama-erp está
# em 1.8.1 (instruções e ferramentas do workshop de Finanças v3) enquanto os demais seguem em 1.7.1; alinhe na próxima release geral.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
python3 - "${TAG:-}" <<'PY'
import json, os, sys
tag = sys.argv[1].lstrip("v") if len(sys.argv) > 1 and sys.argv[1] else None
load = lambda p: json.load(open(p, encoding="utf-8"))
claude_mkt = {p["name"]: p for p in load(".claude-plugin/marketplace.json")["plugins"]}
agents_mkt = {p["name"]: p for p in load(".agents/plugins/marketplace.json")["plugins"]}
INDEPENDENT = {"alameda-dados", "trama-erp"}
errors, versions = [], set()
names = sorted(d for d in os.listdir("plugins") if os.path.isdir(os.path.join("plugins", d)))
if set(names) != set(claude_mkt) or set(names) != set(agents_mkt):
    errors.append(f"plugins/ {names} != marketplaces claude {sorted(claude_mkt)} / agents {sorted(agents_mkt)}")
for n in names:
    a = load(f"plugins/{n}/plugin.json")
    c = load(f"plugins/{n}/.claude-plugin/plugin.json")
    found = {
        "plugin.json": a.get("version"),
        ".claude-plugin/plugin.json": c.get("version"),
        ".claude-plugin/marketplace.json": claude_mkt.get(n, {}).get("version"),
    }
    for label, nm in (("plugin.json", a.get("name")), (".claude-plugin/plugin.json", c.get("name"))):
        if nm != n:
            errors.append(f"{n}: name em {label} = {nm!r}")
    if len(set(found.values())) != 1:
        errors.append(f"{n}: versões divergentes {found}")
    if n in INDEPENDENT:
        print(f"{n}: {found['plugin.json']} (versão própria)")
        continue
    versions.update(found.values())
    print(f"{n}: {found['plugin.json']}")
if tag and versions != {tag}:
    errors.append(f"tag v{tag} não bate com as versões {sorted(map(str, versions))}")
if errors:
    print("\n".join("ERRO: " + e for e in errors), file=sys.stderr)
    sys.exit(1)
print("OK: versões consistentes")
PY
