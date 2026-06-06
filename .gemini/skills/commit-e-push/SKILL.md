---
name: commit-e-push
description: Orienta o processo de commit e push seguindo as convenções do projeto FleetMaster Logistics (Conventional Commits em PT-BR). Use quando o usuário quiser "fazer commit", "commitar", "dar push", "enviar alterações" ou "salvar o trabalho" no git.
---

# Fluxo de Commit e Push no FleetMaster

Este guia define o padrão obrigatório para registrar e enviar alterações no projeto FleetMaster Logistics.

## Regras de Bloqueio e Segurança

### 1. Proibição de Trabalho na Main
- **NUNCA** realize commits diretamente na branch `main`.
- Se estiver na `main`, crie uma nova branch: `git checkout -b minha-branch-de-trabalho`.

### 2. IDs de Tarefa (Shortcut)
- **REGRA CRÍTICA:** **NUNCA** inclua IDs de tarefas (ex: `[sc-123]`) na mensagem de commit.
- IDs devem ser usados APENAS no título da branch (ex: `feature/sc-123-descricao`) e no título do PR.

## Diretrizes de Commit

### 1. Idioma e Estilo
- **Obrigatório**: Mensagens de commit em **Português do Brasil (pt-BR)**.
- **Padrão**: Conventional Commits (`tipo[(escopo)]: descrição`). O escopo é opcional.
- **Tipos válidos**:
  - `feat`: Nova funcionalidade
  - `fix`: Correção de bug
  - `docs`: Documentação
  - `style`: Formatação, lint (StandardRB), sem mudança lógica
  - `refactor`: Mudança na estrutura sem alterar comportamento
  - `perf`: Melhoria de performance
  - `test`: Testes
  - `build`: Build system, dependências (Gemfile, Docker)
  - `ci`: CI/CD (GitHub Actions)
  - `chore`: Manutenção geral, config
  - `revert`: Reverter um commit anterior

- **Escopos Permitidos (opcionais)**: `Core`, `Auth`, `Dashboard`, `Teams`, `Users`, `Infra`, `LandingPage`.

## Fluxo de Execução

### Passo 1: Validação de Ambiente
- Verifique se não está na `main`.
- **Linting (Recomendado)**: Execute `bundle exec standard --fix` para garantir a qualidade do código.
- **Testes (Opcional)**: Recomendado `bundle exec rspec`.

### Passo 2: Preparar o Commit
- Proponha a mensagem seguindo o padrão Conventional Commits em pt-BR.
- **Exemplo**: `feat(Users): adiciona validação de e-mail`.

### Passo 3: Push e Atualização de PR
- Execute `git push origin <sua-branch>`.
- **Atualização de PR**: Após o push, verifique se há um PR aberto (`gh pr view`).
- Se houver, utilize a skill `criar-ou-atualizar-pr` para atualizar a descrição se necessário.

## Checklist Final
- [ ] Fora da branch `main`?
- [ ] Mensagem em PT-BR e segue Conventional Commits?
- [ ] ID da story NÃO está na mensagem de commit?
- [ ] Linting executado?
