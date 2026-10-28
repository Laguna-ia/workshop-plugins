# Plugins dos workshops Laguna

Marketplace dos plugins usados nos workshops da [Laguna AI](https://lagunaai.org). Cada workshop tem a sua empresa fictícia, e toda empresa tem ao menos Drive e e-mail. Este repositório serve os mesmos plugins para o **ChatGPT** (Business/Enterprise, Codex) e para o **Claude** (Claude Code).

Regra de nomes: os plugins de Drive e e-mail aparecem como **Drive &lt;Empresa&gt;** e **Email &lt;Empresa&gt;**. O nome técnico (pasta, manifests, marketplaces e chave do servidor MCP) não muda depois de publicado, para que as instalações existentes continuem se atualizando.

### Vértice (workshop de vendas)

| Plugin | Nome exibido | O que faz | Servidor MCP |
| --- | --- | --- | --- |
| `vertice-crm` | Vértice CRM | CRM da Vértice: contas, contatos, oportunidades, atividades, reuniões, documentos e tarefas. Escritas afetam só a sua carteira e pedem sua aprovação. | `https://lagunaai.org/api/mcp/crm` |
| `vertice-pulso` | Vértice Pulso | Dados de uso do produto (contas, usuários, convites, eventos, integrações, logs e limites contratados) em SQL somente leitura. | `https://lagunaai.org/api/mcp/produto` |
| `vertice-drive` | Drive Vértice | Drive da Vértice: arquivos da empresa e a sua pasta Meus arquivos, onde o assistente salva documentos (DOCX no modelo Vértice), planilhas e textos, só quando você pedir. | `https://lagunaai.org/api/mcp/drive` |
| `vertice-mail` | Email Vértice | Caixa de e-mail do Diretor Comercial da Vértice, com leitura, contatos, respostas e envio de mensagens. Envios pedem sua aprovação. | `https://lagunaai.org/api/mcp/mail` |

### Casa em Dia (workshop de marketing)

| Plugin | Nome exibido | O que faz | Servidor MCP |
| --- | --- | --- | --- |
| `drive-casa-em-dia` | Drive Casa em Dia | Drive da Casa em Dia (manutenção residencial com planos de assinatura): a pasta `Casa em Dia/` é somente leitura para participantes (só instrutores gravam); o assistente salva documentos, planilhas e textos em Meus arquivos, só quando você pedir. | `https://lagunaai.org/api/mcp/casa-em-dia/drive` |
| `email-casa-em-dia` | Email Casa em Dia | Caixa de e-mail de Lívia Andrade, Head de Marketing da Casa em Dia, com leitura, contatos, respostas e envio de mensagens. Envios pedem sua aprovação. | `https://lagunaai.org/api/mcp/casa-em-dia/mail` |

### Astral Ecom (workshop de finanças)

| Plugin | Nome exibido | O que faz | Servidor MCP |
| --- | --- | --- | --- |
| `drive-astral-ecom` | Drive Astral Ecom | Drive da Astral Ecom (plataforma de e-commerce para PMEs): a pasta `Astral Ecom/` da Controladoria é somente leitura para participantes (só instrutores gravam); o assistente salva documentos, planilhas e textos em Meus arquivos, só quando você pedir. | `https://lagunaai.org/api/mcp/astral-ecom/drive` |
| `email-astral-ecom` | Email Astral Ecom | Caixa de e-mail de Bianca Okuma, Controller da Astral Ecom, com leitura, contatos, respostas e envio de mensagens. Envios pedem sua aprovação. | `https://lagunaai.org/api/mcp/astral-ecom/mail` |
| `trama-erp` | Trama ERP | ERP da Trama (workshop de Finanças): vendas, razão, balancete, DRE × orçamento, contas a pagar, notas de entrada e saída com IBS/CBS, produtos e fornecedores. A única escrita é bloquear títulos a pagar, só na sua carteira e com a sua aprovação. | `https://lagunaai.org/api/mcp/trama/erp` |
| `drive-trama` | Drive Trama | Drive da Trama: a pasta `Trama/` (planejamento, políticas, contratos, extratos, vendas, fiscal, modelos) é somente leitura para participantes; o assistente salva documentos, planilhas e textos em Meus arquivos, só quando você pedir. | `https://lagunaai.org/api/mcp/trama/drive` |
| `email-trama` | Email Trama | Caixa de e-mail de Paulo Andrade, Diretor Financeiro da Trama, com leitura, contatos, respostas e envio de mensagens. Envios pedem sua aprovação. | `https://lagunaai.org/api/mcp/trama/mail` |

> **Credenciais:** os plugins não guardam token, senha nem chave. O acesso é feito por OAuth: na primeira vez que o plugin é usado, você entra com a sua conta Laguna e o ChatGPT/Claude guarda a autorização do seu lado. Nada de credencial deve ser commitado neste repositório (ele é público).

## Instalar no ChatGPT (admin de workspace Business/Enterprise)

Recomendado: os plugins se atualizam sozinhos a cada nova versão publicada aqui.

1. Em **Workspace settings > Plugins**, clique em **Add > Import marketplace**.
2. Cole a URL do repositório: `https://github.com/Laguna-ia/workshop-plugins`. Deixe o campo de branch vazio (usa `main`).
3. Os plugins **Vértice CRM**, **Vértice Pulso**, **Drive Vértice**, **Email Vértice**, **Drive Casa em Dia**, **Email Casa em Dia**, **Drive Astral Ecom** e **Email Astral Ecom** aparecem no diretório de plugins do workspace. Ative só os da empresa do workshop em andamento, se preferir. O ChatGPT sincroniza o marketplace uma vez por dia; para puxar uma versão nova na hora, use **Sync now**.
4. Se o workspace já tinha plugins instalados por ZIP, remova as instalações antigas do mesmo plugin para evitar duplicatas, inclusive versões antigas com os nomes **Vértice Drive**, **Vértice Mail** ou **Email Vertice**. Se o workspace importou o marketplace pela URL antiga (`vertice-plugins`), o GitHub redireciona, mas vale reimportar pela URL nova.
5. Cada pessoa, ao usar o plugin pela primeira vez, faz login com a conta Laguna.

No Codex CLI: `codex plugin marketplace add Laguna-ia/workshop-plugins`.

## Instalar no Claude (Claude Code)

```text
/plugin marketplace add Laguna-ia/workshop-plugins

# Vértice
/plugin install vertice-crm@laguna
/plugin install vertice-pulso@laguna
/plugin install vertice-drive@laguna
/plugin install vertice-mail@laguna

# Casa em Dia
/plugin install drive-casa-em-dia@laguna
/plugin install email-casa-em-dia@laguna

# Astral Ecom
/plugin install drive-astral-ecom@laguna
/plugin install email-astral-ecom@laguna
/plugin install trama-erp@laguna
/plugin install drive-trama@laguna
/plugin install email-trama@laguna
```

Pelo terminal: `claude plugin marketplace add Laguna-ia/workshop-plugins` e `claude plugin install vertice-crm@laguna`. Para receber versões novas: `/plugin marketplace update laguna`. No primeiro uso, autorize o servidor MCP (login Laguna) em `/mcp`.

## Instalar por zip

Para quem não é admin do workspace ou usa ChatGPT Plus/Pro: baixe o zip de cada plugin (`vertice-crm.zip`, `vertice-pulso.zip`, `vertice-drive.zip`, `vertice-mail.zip`, `drive-casa-em-dia.zip`, `email-casa-em-dia.zip`, `drive-astral-ecom.zip`, `email-astral-ecom.zip`, `trama-erp.zip`, `drive-trama.zip`, `email-trama.zip`) na página de [Releases](https://github.com/Laguna-ia/workshop-plugins/releases/latest) ou em [lagunaai.org/plataforma/empresa/plugins](https://lagunaai.org/plataforma/empresa/plugins) e siga as instruções de lá. Instalações por zip não se atualizam sozinhas.

## Estrutura

```text
.agents/plugins/marketplace.json     marketplace do ChatGPT/Codex
.claude-plugin/marketplace.json      marketplace do Claude
plugins/<nome>/plugin.json           manifest Agent Plugins 1.0 (ChatGPT), com extensions.com.openai
plugins/<nome>/mcp.json              servidor MCP (streamable-http)
plugins/<nome>/skills/<nome>/SKILL.md
plugins/<nome>/assets/               ícone e logo
plugins/<nome>/.claude-plugin/plugin.json   manifest do Claude (MCP inline, type "http")
experiments/                         snapshots fora dos índices de marketplace
scripts/build-zips.sh                gera dist/<nome>.zip (mesmo layout dos zips do site)
scripts/check-versions.sh            confere se as versões dos manifests batem
```

O nome técnico de cada plugin é o mesmo na pasta, nos manifests e nos dois marketplaces. Os plugins da Vértice mantêm os identificadores `vertice-drive` e `vertice-mail` para atualizar instalações existentes; os nomes exibidos passam a ser **Drive Vértice** e **Email Vértice**. Plugins de empresas novas usam `drive-<empresa>` e `email-<empresa>`. O pacote privado de teste continua guardado em `experiments/`, fora dos índices ativos.

## Lançar uma versão

1. Faça as mudanças em `plugins/<nome>/` (skill, manifest, MCP). Se mudar a URL do MCP, mude em `mcp.json` **e** em `.claude-plugin/plugin.json`.
2. Suba a versão (semver) em **todos** os manifests: `plugins/*/plugin.json`, `plugins/*/.claude-plugin/plugin.json` e `.claude-plugin/marketplace.json`.
3. Rode `./scripts/check-versions.sh` e `./scripts/build-zips.sh`; se tiver o Claude Code, `claude plugin validate .`.
4. Faça commit e push para `main`. O ChatGPT sincroniza o marketplace diariamente; para atualizar na hora, use **Sync now**. No Claude, use `/plugin marketplace update laguna`.
5. Para publicar ZIPs, crie e envie uma tag depois do commit:

   ```bash
   git tag v1.6.1
   git push origin main v1.6.1
   ```

6. Este repositório não tem um workflow de GitHub Actions para a release. Depois de gerar `dist/`, publique manualmente o GitHub Release com os arquivos ZIP; se o app também servir os ZIPs em `lagunaai.org`, atualize-os lá.
