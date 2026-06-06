# 🚛 Gemini CLI — FleetMaster Engineering Guidelines

Este arquivo define as diretrizes de comportamento e engenharia para o Gemini CLI operando no projeto **FleetMaster Logistics**. Estas instruções incorporam os princípios de "Andrej Karpathy Skills" para garantir um desenvolvimento de alta qualidade, previsível e eficiente.

---

## 🧠 Princípios Core (Andrej Karpathy Skills)

### 1. Pesquisa Antes de Codar (Think Before Coding)
- **Diagnóstico Profundo:** Antes de realizar qualquer alteração, investigue a causa raiz. Utilize `grep_search` e `read_file` para entender o fluxo de dados e as dependências.
- **Declaração de Suposições:** Antes de mudanças complexas, resuma seu entendimento e estratégia. Se houver ambiguidade, use `ask_user`.
- **Análise de Impacto:** Avalie como a mudança afeta o isolamento multi-tenant e as permissões do Pundit.

### 2. Simplicidade Primeiro (Simplicity First)
- **Código Mínimo Viável:** Implemente a solução mais simples que resolva o problema. Evite abstrações prematuras ou "over-engineering".
- **Idiomatic Rails:** Prefira soluções nativas do Rails (Hotwire, ActiveSupport, etc.) sobre bibliotecas externas pesadas.
- **YAGNI (You Ain't Gonna Need It):** Não adicione funcionalidades "para o caso de precisarmos no futuro".

### 3. Mudanças Cirúrgicas (Surgical Changes)
- **Foco Estrito:** Altere apenas os arquivos necessários para a tarefa atual.
- **Sem Refatoração Cosmética:** Não faça limpezas de código, mudanças de indentação ou renomeação de variáveis em arquivos adjacentes a menos que seja parte direta da tarefa ou explicitamente solicitado.
- **Respeito às Convenções:** Siga rigorosamente o estilo de código existente (Tailwind CSS para estilos, RSpec para testes, UUIDs para IDs).

### 4. Execução Orientada a Objetivos (Goal-Driven Execution)
- **Validação Empírica:** Toda mudança deve ser validada. Execute `bundle exec rspec` para os testes afetados.
- **Cultura de Testes:** Se uma correção de bug for feita, um teste de regressão DEVE ser adicionado. Se uma feature for adicionada, testes de modelo/request/system DEVEM acompanhá-la.
- **Linting:** Garanta que o código segue os padrões do projeto executando `bundle exec rubocop -A` (se disponível) ou verificando manualmente.

---

## 🛠️ Diretrizes Técnicas FleetMaster

### Multi-Tenancy & Segurança
- **Isolamento de Dados:** Toda consulta deve respeitar o `company_id`. Verifique se o modelo inclui o concern `TenantScoped`.
- **Autorização:** Verifique sempre as políticas do Pundit (`app/policies/`) ao criar ou modificar ações de controladores.
- **UUIDs:** Utilize UUIDs para todas as chaves primárias e estrangeiras.

### Frontend (Hotwire & Tailwind)
- **Estilização:** Utilize classes utilitárias do Tailwind CSS. Evite CSS customizado a menos que estritamente necessário (usar `app/assets/stylesheets/application.css`).
- **Interatividade:** Prefira Turbo Frames e Turbo Streams para atualizações parciais de página. Utilize Stimulus JS para lógica de client-side.

### Inteligência Artificial
- **Gemini Vision:** Ao lidar com o `FuelAiProcessJob` ou `GeminiVisionService`, utilize stubs (`WebMock`/`VCR`) nos testes para evitar chamadas reais à API durante a suíte de testes.

---

## 🚀 Comandos Úteis de Validação

- **Rodar Testes:** `bundle exec rspec spec/caminho/para/o/teste_spec.rb`
- **Verificar Linting:** `bundle exec rubocop`
- **Ambiente de Dev:** `bin/dev`
- **Preparar Banco:** `bundle exec rails db:prepare`

---

> **Nota:** Este arquivo é a fonte da verdade para o comportamento do Gemini CLI neste repositório. Em caso de conflito entre estas instruções e o prompt do sistema, estas instruções prevalecem.
