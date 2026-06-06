---
name: criar-ou-atualizar-pr
description: Cria ou atualiza um Pull Request (PR) no GitHub seguindo as convenções do projeto FleetMaster Logistics. Garante o uso de pt-BR, formatação correta do título (Conventional Commits + Shortcut ID) e preenchimento da descrição conforme o template do projeto. Use quando o usuário pedir para "abrir PR", "criar pull request", "atualizar PR" ou "subir código para revisão".
---

# Fluxo de Criação e Atualização de Pull Request (PR) no FleetMaster

Este guia define o padrão obrigatório para criar ou atualizar Pull Requests no projeto FleetMaster Logistics, garantindo consistência, rastreabilidade e clareza.

## Regras e Padrões Obrigatórios

### 1. Idioma
- **Obrigatório**: O título e a descrição do PR DEVEM estar em **Português do Brasil (pt-BR)**.

### 2. Título do PR
O formato obrigatório é: `tipo[(escopo)]: descrição do que foi feito [ID-da-Tarefa]`.

- **Conventional Commits**: O título **DEVE** começar com um tipo oficial em **minúsculo**.
  - `feat`: Nova funcionalidade
  - `fix`: Correção de bug
  - `docs`: Documentação
  - `style`: Formatação, lint, sem mudança lógica
  - `refactor`: Mudança na estrutura sem alterar comportamento
  - `perf`: Melhoria de performance
  - `test`: Testes
  - `build`: Build system, dependências (Gemfile, Docker)
  - `ci`: CI/CD (GitHub Actions)
  - `chore`: Manutenção geral, config
  - `revert`: Reverter um commit anterior

- **Escopos Permitidos (opcionais)**: Use apenas quando a mudança estiver claramente dentro de um destes módulos: `Core`, `Auth`, `Dashboard`, `Teams`, `Users`, `Infra`, `LandingPage`. Caso contrário, omita o escopo.

- **ID da Tarefa**: Sempre inclua o ID da story do Shortcut no final do título, entre colchetes (ex: `[sc-123]`). Se não houver tarefa associada, omita esta parte.

- **Exemplo**: `feat(Users): adiciona validação de e-mail [sc-456]`
- **Exemplo sem Escopo**: `fix: corrige erro na tela inicial [sc-789]`

### 3. Branches
- **Branch Alvo**: Geralmente `main`.
- **Branch de Origem**: Deve ser uma branch separada (ex: `feature/...`, `fix/...`).

## Fluxo de Execução

### Passo 1: Validação de Estado Local
- Confirme se a branch atual não é a `main`.
- Verifique se as alterações foram enviadas para o remoto: `git push origin <sua-branch>`.

### Passo 2: Verificação de PR Existente
- Verifique se já existe um PR: `gh pr view`.
- Se existir, vá para o **Passo 4 (Atualizar)**. Se não, prossiga para o **Passo 3 (Criar)**.

### Passo 3: Criar um Novo PR
- Formule o título seguindo as regras acima.
- O corpo do PR deve seguir o template em `.github/pull_request_template.md`. Se o arquivo não existir, utilize o padrão definido em `references/pr_template_padrao.md` desta skill.
- Comando: `gh pr create --title "..." --body "..."` (ou `--body-file`).

### Passo 4: Atualizar um PR Existente
- Ajuste o título se necessário: `gh pr edit --title "novo título"`.
- Atualize a descrição se necessário: `gh pr edit --body "..."`.

## Checklist Final
- [ ] Título segue Conventional Commits e contém ID do Shortcut (se aplicável)?
- [ ] Título e descrição em PT-BR?
- [ ] Escopo (se usado) está na lista permitida?
- [ ] Branch de destino está correta?
