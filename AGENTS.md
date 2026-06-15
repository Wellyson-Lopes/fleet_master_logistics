# 🤖 FleetMaster Logistics - Agentes e Diretrizes

Este documento descreve o projeto **FleetMaster Logistics** e as diretrizes operacionais para o Gemini CLI e outros agentes de IA que atuam neste repositório.

## 🚛 Sobre o Projeto

O **FleetMaster Logistics** é um sistema avançado de gestão de frotas e logística. O projeto foca em:
- **Alta Performance:** Utilizando Ruby on Rails com Hotwire (Turbo/Stimulus) para uma experiência de usuário fluida sem a complexidade de SPAs pesados.
- **Arquitetura Multi-Tenant:** Isolamento rigoroso de dados por empresa (`company_id`).
- **Qualidade de Código:** Seguindo padrões rigorosos de engenharia, testes automatizados (RSpec) e linting (RuboCop).
- **Design Moderno:** Interface construída com Tailwind CSS seguindo o Design System do FleetMaster.

## 🛠️ Stack Tecnológica

### Backend (Ruby on Rails)
- **Ruby:** 3.4.9
- **Rails:** ~> 8.0.1
- **Banco de Dados:** PostgreSQL 16 (via `pg` ~> 1.1)
- **Cache & Background Jobs:** 
  - Redis 7 (via `redis` ~> 5.0)
  - Sidekiq ~> 7.2
  - Solid Queue, Solid Cache, Solid Cable (Rails 8 defaults)
- **Autenticação:** Devise (com suporte a JWT e Convites)
- **Servidor Web:** Puma >= 5.0 / Thruster (aceleração de ativos)
- **Deployment:** Kamal (Container-based)

### Frontend (Web)
- **Engine:** Hotwire (Turbo-rails, Stimulus-rails)
- **Estilização:** Tailwind CSS (via `tailwindcss-rails`)
- **Asset Pipeline:** Propshaft
- **JS Bundling:** Import Maps (ESM)

### Mobile (React Native / Expo)
- **Plataforma:** Expo ~54.0.0
- **Core:** React 19.1.0, React-Native 0.81.5
- **Navegação:** Expo Router ~6.0.24
- **Estilização:** Styled Components ^6.4.2
- **Ícones:** Lucide React Native ^1.18.0
- **Segurança:** Expo Secure Store ~15.0.8
- **Linguagem:** TypeScript ~5.9.2

### Infraestrutura & DevOps
- **Containerização:** Docker & Docker Compose
- **Imagens Base:** Alpine Linux (para Redis e Postgres)
- **CI/CD:** GitHub Actions (configurado em `.github/workflows/ci.yml`)
- **Análise Estática:** StandardRB, RuboCop, Brakeman

## 🧠 Diretrizes para o Gemini CLI (Mandatórias)

Sempre que o Gemini CLI for iniciado ou receber um novo comando/diretiva do usuário, ele deve seguir rigorosamente os passos abaixo:

### 1. Verificação de Habilidades (Skills)
Antes de iniciar qualquer tarefa, o Gemini **DEVE** ler as descrições de todas as habilidades disponíveis no projeto para identificar qual(is) se aplica(m) ao contexto atual.
As habilidades disponíveis incluem:
- **revisar-codigo:** Para revisões de PR e validações de padrões Rails.
- **padrao-visual-mobile:** Para frontend React Native com Styled Components.
- **padrao-visual:** Para frontend web (Tailwind CSS/Hotwire).
- **documentacao-yard:** Para documentação técnica em Ruby.
- **criar-story:** Para registro de tarefas no Shortcut.
- **criar-ou-atualizar-pr:** Para automação de Pull Requests.
- **commit-e-push:** Para versionamento seguindo Conventional Commits.
- **skill-creator:** Para criar novas capacidades.

**Ação:** Ative a habilidade necessária usando `activate_skill(name: "nome-da-habilidade")` antes de prosseguir com a implementação se a tarefa corresponder a uma especialidade.

### 2. Prioridade de Contexto
As instruções contidas no arquivo `GEMINI.md` na raiz do projeto têm precedência absoluta sobre as regras genéricas. O Gemini deve consultar o `GEMINI.md` para diretrizes de engenharia específicas do FleetMaster.

### 3. Comunicação
- Toda a comunicação deve ser em **Português do Brasil (pt-BR)**.
- Seja conciso e técnico, evitando preâmbulos desnecessários.
- Explique brevemente sua estratégia antes de executar comandos que alterem o sistema.

### 4. Ciclo de Vida: Pesquisa -> Estratégia -> Execução
- **Nunca codifique sem pesquisar:** Use `grep_search` e `read_file` para entender o código existente.
- **Validação:** Toda alteração de código deve ser acompanhada de testes ou verificação manual via comandos do projeto.

---
*Este arquivo deve ser mantido atualizado conforme novas ferramentas e fluxos de trabalho forem integrados ao FleetMaster Logistics.*
