---
name: documentacao-yard
description: Cria ou atualiza a documentação YARD para classes e métodos Ruby seguindo as regras do projeto FleetMaster Logistics. Use quando o usuário pedir documentação YARD, docstrings Ruby, ou ao adicionar/alterar classes ou métodos que precisem de documentação. Todos os textos do YARD devem ser em Português do Brasil (pt-BR).
---

# Documentação YARD no FleetMaster

## Quando aplicar

- Ao criar ou alterar classes, módulos ou métodos em `app/`, `lib/` ou `config/`.
- Quando o usuário pedir para documentar código, adicionar YARD ou "docstrings" em Ruby.
- **SEMPRE** em novas classes e métodos públicos.

## Idioma

**Toda a documentação YARD deve ser em Português do Brasil (pt-BR)**. Resumos, descrições e textos de tags devem ser escritos em português.

## Estrutura por elemento

### Classe ou módulo

1. **Primeira linha**: Resumo de uma frase (o que é / responsabilidade).
2. **Linha em branco** e, se necessário, parágrafos explicativos.
3. **Tags**:
   - ` @example` para uso típico.
   - ` @see` para referências relacionadas.

```ruby
# Service para processamento de imagens via IA.
#
# @example Processar uma imagem de combustível
#   FuelAiProcessJob.perform_later(attachment_id)
#
class FuelAiProcessJob < ApplicationJob
```

### Método (público ou privado)

1. **Primeira linha**: Resumo de uma frase.
2. **Tags obrigatórias (nesta ordem)**:
   - ` @param nome [Tipo] Descrição`
   - ` @example` (Obrigatório para actions de controller)
   - ` @return [Tipo] Descrição`

```ruby
# Verifica se o usuário é o dono da conta.
#
# @return [Boolean] verdadeiro se for dono
def owner?
```

### Actions de Controller

**OBRIGATÓRIO**: Todas as actions de um controller devem incluir um `@example URL` mostrando o método HTTP e o PATH.

```ruby
# Lista os times da empresa.
#
# @example URL
#   GET /teams
#
# @return [void]
def index
```

## Regras e Convenções

- **frozen_string_literal**: Sempre inclua `# frozen_string_literal: true` no topo.
- **attr_reader**: Não documente, mantenha em uma linha.
- **Modelos**: Não documente atributos de models (o Schema Information já cuida disso).
- **Tipos**: Use tipos Ruby comuns (`String`, `Integer`, `Boolean`, `Hash`, `Array`, `User`, etc.).

## Checklist rápido

- [ ] Classe/módulo com resumo.
- [ ] Método público com ` @param`, ` @example` e ` @return`.
- [ ] Todo o texto em pt-BR.
- [ ] `# frozen_string_literal: true` presente.

Para uma lista completa de tags e tipos, consulte [referencia.md](references/referencia.md).
