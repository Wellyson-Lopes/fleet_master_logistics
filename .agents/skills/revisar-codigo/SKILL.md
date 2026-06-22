---
name: revisar-codigo
description: Revisa um Pull Request ou valida alterações locais antes da abertura do PR, seguindo a arquitetura do FleetMaster Logistics e padrões Rails. Use quando o usuário pedir um "code review", "revisar alterações", "checar padrões" ou "validar o código".
argument-hint: "[branch base (padrão: detecção automática ou main)]"
---

# FleetMaster Code Review & Pre-PR Check

Esta skill realiza uma análise profunda das alterações para garantir que o código segue os padrões do FleetMaster Logistics. Ela deve considerar o estado atual do código (incluindo mudanças não commitadas) e comparar com a branch base correta.

## Passo 1: Coletar Contexto e Modo de Operação

### 1.1 Identificar a Branch Base
Se não for fornecida como argumento, determine a branch base:
1. Verifique a branch de upstream (`git rev-parse --abbrev-ref --symbolic-full-name @{u}`).
2. Se não houver, tente identificar se ela foi criada a partir de outra branch (stacked branch) ou use `main` como fallback.

### 1.2 Coletar Dados do Git
Analise todo o trabalho realizado na branch atual em relação à base:
- **Mudanças Totais:** `git diff $(git merge-base HEAD <base>)`.
- **Status Atual:** `git status --short`.
- **Contexto PR:** `gh pr view --json title,url,number 2>/dev/null || echo "MODO_PRE_PR"`.

## Passo 2: Entender a Alteração e Requisitos

1. **Vincular Story:** Busque o ID do Shortcut (`sc-XXXXX`) no nome da branch ou commits e valide o contexto se possível.
2. **Leitura Integral:** Leia os arquivos alterados por completo para entender o contexto.
3. **Análise de Camadas:** Valide o respeito às responsabilidades definidas no `GEMINI.md`.

## Passo 3: Aplicar Diretrizes de Revisão (GEMINI.md)

Valide rigorosamente:
1. **Padrões Ruby/Rails:** Ruby 3.4.9, Rails 8.0.1.
2. **Datas e Fuso Horário (CRÍTICO):** Uso obrigatório de `Date.current` ou `Time.zone.today` (NUNCA `Date.today`). Uso de `Time.current` (NUNCA `Time.now`). Reporte como **Problema Crítico** se violado.
3. **Complexidade de Métodos (CRÍTICO):** Métodos não devem ter mais de 15 linhas. Se exceder, reporte como **Problema Crítico (Blocker)**.
4. **Documentação:** Comentários e documentação em pt-BR.
5. **Segurança & Multi-Tenancy:** Uso de `TenantScoped` e respeito ao `company_id`. Verificação de políticas do Pundit (se aplicável). Uso de UUIDs.
6. **UI/UX:** **Uso exclusivo de Tailwind CSS com Flowbite.** 
   - **PROIBIÇÃO CRÍTICA:** Nunca usar estilos inline (`style="..."`) ou JavaScript inline (`<script>...</script>`) nos arquivos de view (.html.erb). 
   - CSS deve estar em arquivos de folha de estilo seguindo o Tailwind.
   - JavaScript deve ser implementado exclusivamente via **Stimulus Controllers** ou **Turbo**, seguindo o padrão **Hotwire**.
   - Proibido Bootstrap ou CSS customizado pesado.
7. **Idioma:** Mensagens de erro, documentação e comentários devem estar em **pt-BR**. (Nota: Nomes de classes e métodos seguem o padrão Rails/Inglês do projeto).

## Passo 4: Produzir o Relatório

Apresente o relatório EXCLUSIVAMENTE em Português do Brasil (pt-BR).

---\n
## 🔍 Análise: `<nome_da_branch>`

**Modo:** `<🚀 Revisão de PR | 🛠️ Validação Pré-PR>`
**Base de Comparação:** `<nome_da_base>`
**Story:** `<ID do Shortcut | "Não encontrada">`
**Risco:** `<Baixo | Médio | Alto>` - `<justificativa>`

### 📝 Resumo
`<resumo de 2-3 frases do que as alterações fazem e se elas atingem o objetivo>`

### 🔴 Problemas Críticos (Blockers)
- **[CRITICAL-1]** `<Descrição do problema>`
- **[CRITICAL-2]** `<Descrição do problema>`
`<Se nenhum, "Nenhum encontrado.">`

### 🟡 Recomendações (Major)
- **[MAJOR-1]** `<Descrição da recomendação>`
`<Se nenhum, "Nenhum encontrado.">`

### 🟢 Sugestões Menores (Minor)
- **[MINOR-1]** `<Descrição da sugestão>`
`<Se nenhum, "Nenhum encontrado.">`

### 🌟 O Que Foi Bem Feito
`<Destaques positivos da implementação.>`

### 🧪 Cobertura de Testes
- **Novo comportamento coberto?** `<Sim/Não/Parcial>`
- **Testes faltantes:** `<lista de arquivos/cenários>`

---\n
## 🏁 CONCLUSÕES (OBRIGATÓRIO)

**Nota Geral:** `<Nota de 0 a 10>`

**Veredito:**
- **Modo PR:** `<APROVAR | SOLICITAR ALTERAÇÕES | COMENTAR>`
- **Modo Pre-PR:** `<PRONTO PARA ENVIO | AJUSTES NECESSÁRIOS>`

**Resumo Executivo:**
`<Pequeno resumo para leitura rápida (2-3 linhas) sintetizando o estado geral do código.>`

---\n
## Diretrizes para a IA (Mandatórias)

1. **SEMPRE** mostre a seção `🏁 CONCLUSÕES` ao final.
2. **Use Identificadores Únicos**: `[CRITICAL-X]`, `[MAJOR-X]`, `[MINOR-X]`.
3. **Analise o código atual**, independentemente de estar staged ou não.
4. **Seja específico**: Referencie arquivos e linhas.
