# 🚛 FleetMaster Logistics — SaaS v2.0
> Plataforma SaaS B2B Multi-Tenant para gestão logística de distribuidoras de materiais de construção.

O **FleetMaster** é uma plataforma SaaS robusta desenvolvida para resolver os desafios operacionais de distribuidoras de cimento, areia, brita, blocos e outros insumos de construção, substituindo processos manuais (como papel e WhatsApp) por automação e controle em tempo real.

Na versão 2.0, o sistema opera em um modelo **SaaS Multi-Tenant** sob assinatura mensal ou anual, garantindo completo isolamento de dados das empresas contratantes, customização de marca (*white-label*) e integração com inteligência artificial para leitura de comprovantes.

---

## 🛠️ Stack Técnica Completa

O FleetMaster foi planejado como um ecossistema integrado que une facilidade de manutenção a alta performance.

| Camada | Tecnologia | Responsabilidade |
| :--- | :--- | :--- |
| **Landing Page** | Rails ERB + Tailwind + Flowbite | Vitrine de vendas, visualização de planos, cadastro do tenant e login. |
| **Sistema Web** | Ruby on Rails 8.0 / 7.1 + Hotwire | Painel administrativo para gestores (dashboards, relatórios, CRUDs, alertas). |
| **API Mobile** | Rails API Namespace `/api/v1` + JWT | Servidor de endpoints JSON seguros para o app dos motoristas. |
| **App Mobile** | React Native + Expo SDK 51 | Interface dedicada aos motoristas em campo (viagens, abastecimento, ocorrências). |
| **Banco de Dados** | PostgreSQL 16 | Persistência de dados segura com chaves UUID e isolamento multi-tenant por `company_id`. |
| **Cache & Filas** | Redis 7 | Gerenciamento de sessões, cache e filas de segundo plano para o Sidekiq. |
| **Workers** | Sidekiq + sidekiq-scheduler | Execução de jobs assíncronos (alertas de CNH, verificações de assinatura, IA). |
| **Storage** | Active Storage + Cloudflare R2 | Armazenamento de fotos de ocorrências, comprovantes e logos de empresas (compatível com S3). |
| **Inteligência Artificial** | Google Gemini 1.5 Flash (Vision) | Leitura automática de comprovantes de abastecimento com IA OCR (Planos Pro+). |
| **Proxy & Servidor** | Nginx + Puma | Proxy reverso, terminação SSL, limite de requisições e entrega de assets. |
| **Ambiente** | Docker + docker-compose | Conteneirização reprodutível de todos os serviços em desenvolvimento e produção. |

---

## 💎 Modelo SaaS e Planos de Assinatura

Qualquer distribuidora no Brasil pode realizar o cadastro na Landing Page, escolher um plano de assinatura e começar a gerenciar sua logística em minutos. O onboarding conta com **14 dias de teste gratuito (Trial)**.

### 📊 Comparador de Planos

| Recurso / Limite | Starter (R$ 197/mês) | Professional (R$ 397/mês) ⭐️ | Enterprise (R$ 797/mês) |
| :--- | :---: | :---: | :---: |
| **Preço Anual (20% off)** | R$ 157/mês | R$ 317/mês | R$ 637/mês |
| **Funcionários (Web)** | Até 3 | Até 10 | Ilimitados |
| **Motoristas (App)** | Até 5 | Até 20 | Ilimitados |
| **Caminhões na Frota** | Até 5 | Até 20 | Ilimitados |
| **Dashboards & Viagens** | Incluído | Incluído | Incluído |
| **Relatórios (PDF/Excel)**| Incluído | Incluído | Incluído |
| **Alertas (CNH, Seguro)** | Incluído | Incluído | Incluído |
| **Controle de Abastecimento** | Incluído | Incluído | Incluído |
| **Personalização de Logo**| Incluído | Incluído | Incluído |
| **IA Gemini (OCR)** | Não disponível | **Habilitado** | **Habilitado** |
| **Suporte** | E-mail | WhatsApp + E-mail | WhatsApp Dedicado + E-mail |

> [!IMPORTANT]
> **Controle de Limites**: O sistema possui o serviço `PlanLimitService` que valida os limites em tempo real. Ao atingir o teto de cadastro de funcionários, motoristas ou caminhões do plano, o sistema bloqueia novos registros e exibe um modal ou tooltip direcionando o usuário para o upgrade de assinatura.

---

## 🛡️ Arquitetura Multi-Tenant e Segurança

O isolamento lógico de dados é o coração do SaaS do FleetMaster. Todas as tabelas operacionais utilizam **UUID** como chave primária e possuem a coluna `company_id` como chave estrangeira obrigatória.

*   **Isolamento Automático**: O `ApplicationRecord` inclui o concern `TenantScoped`, aplicando automaticamente um escopo global padrão: `where(company_id: Current.company.id)`.
*   **Contexto Global**: O objeto `Current.company` (usando `CurrentAttributes` do Rails) é inicializado no login do usuário a partir da sessão ativa.
*   **Autorização Precisa**: A biblioteca **Pundit** gerencia as permissões de acesso com base no papel do usuário (`viewer`, `manager`, `admin`) e garante que `record.company_id == current_user.company_id`.
*   **Segurança de API Mobile**: O acesso dos motoristas à API é protegido por tokens **JWT** com tempo de expiração de 24h e lista de revogação de tokens (`denylist`) no banco de dados.
*   **Adequação LGPD**:
    *   Fotos de comprovantes e ocorrências no Cloudflare R2 são protegidas por URLs assinadas temporárias que expiram em 1 hora.
    *   O painel de configurações possui uma opção de exclusão completa de dados do Tenant (*soft delete* imediato seguido de processo de purga definitiva do banco e storage em 30 dias via Sidekiq Worker).

---

## 🧪 Estratégia de Testes BDD (RSpec)

O ecossistema é coberto por testes robustos seguindo as práticas de BDD. A cobertura de testes mínima obrigatória é de **85%**, com verificação no CI do GitHub Actions (impedindo merge se a cobertura cair).

*   **Modelos (`spec/models/`)**: Validações de CNPJ (`cpf_cnpj`), integridade, unicidade de e-mails de tenants, validações de CNH do motorista.
*   **Políticas (`spec/policies/`)**: Garante o isolamento completo entre Tenants no Pundit e validação de permissões de papéis.
*   **Serviços (`spec/services/`)**: Cobertura de regras de negócios complexas do `GeminiVisionService` e `PlanLimitService`.
*   **Integração API (`spec/requests/`)**: Validação de rotas JSON com autenticação baseada em JWT para o app dos motoristas.
*   **Sistema E2E (`spec/system/`)**: Testes ponta a ponta dos fluxos web simulando cliques em navegadores reais usando Capybara e Google Chrome Headless.
*   **Alertas Temporais**: Testados com a gem `Timecop` para simular alertas gerados 60, 30 e 15 dias antes da expiração de CNHs de motoristas e documentos de caminhões.
*   **Stubs Externos**: Uso de `WebMock` e `VCR` para simular e gravar retornos reais da API de IA do Google Gemini.

---

## 💻 Instruções de Instalação e Execução

### Pré-requisitos
*   Ruby `~> 3.2` ou Docker instalado
*   PostgreSQL 16 e Redis 7 configurados

### 🚀 Executando com Docker (Recomendado)

1. Clone o repositório em sua máquina local:
   ```bash
   git clone https://github.com/Wellyson-Lopes/fleet_master_logistics.git
   cd fleet_master_logistics
   ```

2. Crie o arquivo `.env` a partir do modelo e configure suas variáveis sensíveis:
   ```bash
   cp .env.example .env
   ```

3. Inicie os containers com o Docker Compose:
   ```bash
   docker-compose up --build
   ```

4. Acesse a aplicação em seu navegador:
   *   **Landing Page e Painel**: `http://localhost:3000`

---

### 🛠️ Executando Localmente (Sem Docker)

1. Instale as dependências Ruby listadas no `Gemfile`:
   ```bash
   bundle install
   ```

2. Inicialize o banco de dados (Criação, Migração e Carregamento de Seeds dos Planos):
   ```bash
   bundle exec rails db:prepare
   ```

3. Compile a folha de estilos inicial do Tailwind CSS v4:
   ```bash
   bundle exec rails tailwindcss:build
   ```

4. Inicie o servidor de desenvolvimento local (Puma + Tailwind CSS Watcher):
   ```bash
   bundle exec bin/dev
   ```

---

## 📅 Roteiro de Desenvolvimento (Sprints)

*   **Sprint 0 — Landing Page e SaaS Foundation (Semanas 1-2)**:
    *   Setup do projeto Rails e RSpec com SimpleCov (cobertura 85%).
    *   Configuração do Docker-Compose e pipeline de assets Tailwind CSS + Flowbite.
    *   Criação das tabelas `companies`, `plans` e desenvolvimento da infraestrutura de isolamento `TenantScoped`.
    *   Desenvolvimento da Landing Page pública e do fluxo de Onboarding multi-step integrado com Stripe/Pagar.me.
*   **Sprints 1 a 5 — MVP Operacional**:
    *   Setup de login para funcionários (web) e motoristas (mobile via JWT).
    *   CRUDs operacionais protegidos pelo controle do `PlanLimitService`.
    *   Desenvolvimento de rotas/viagens da API do motorista e uploads de mídia para o Cloudflare R2 com prefixo de empresa.
    *   Exportação de relatórios PDF e planilhas Excel customizados com a logo do Tenant.
*   **Sprint 6 — IA Gemini (Professional+)**:
    *   Integração do job assíncrono `FuelAiProcessJob` que consome as APIs de Vision do Google Gemini para ler comprovantes de abastecimento por imagem, validando previamente se a empresa contratante possui o plano de IA habilitado.

---

### 📄 Licença
Este projeto é de propriedade intelectual fechada e exclusivo da plataforma **FleetMaster Logistics**. Todos os direitos reservados.
