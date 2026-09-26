# FleetMaster Logistics — Plano Completo de Implementação do Sistema
 
> **Para workers agênticos:** SUB-SKILL OBRIGATÓRIA: Use superpowers:executing-plans para implementar este plano tarefa por tarefa. As etapas usam sintaxe de checkbox (`- [ ]`) para rastreamento.
 
**Objetivo:** Transformar o FleetMaster Logistics em uma plataforma completa, ponta a ponta, de logística e gestão de frotas, pronta para venda em larga escala para dois públicos principais: (1) pequenas e médias mercearias/distribuidoras que precisam gerenciar entregas com caminhões e motoristas, e (2) empresas de locação de máquinas e equipamentos (com ou sem operador). O sistema é dividido em duas frentes: **Sistema Web** (secretários/administradores) e **App do Motorista** (mobile, dados restritos ao próprio motorista). Inclui: convite de motorista por código enviado por e-mail com criação de senha, API mobile do motorista com rastreamento de localização em tempo real, monitoramento ao vivo de veículos em rota, locação de máquinas e equipamentos com precificação dinâmica, cadastro de clientes, integração de pagamento Asaas (agora vinculada a **planos de assinatura do próprio sistema**, não mais a cobranças avulsas), alertas de vencimento de documentos e sistema de notificações, exportação de relatórios em Excel/PDF, modo escuro, e uma landing page comercial com checkout de planos via Asaas.
 
**Arquitetura:** Rails 8 multi-tenant (`TenantScoped`), autenticação mobile com Devise + JWT, políticas de autorização com Pundit (`Authorizable`), front-end com Stimulus JS + Tailwind CSS, ActiveStorage para uploads (fotos de perfil, veículo, comprovantes, notas fiscais), Solid Queue para jobs assíncronos, gateway de pagamento Asaas, WebSockets/ActionCable para notificações e localização em tempo real.
 
**Stack Técnica:** Rails 8.0.5, Ruby 3.4.9, PostgreSQL 16 (porta 5433), Tailwind CSS, Hotwire (Turbo + Stimulus), Devise, Devise-JWT, RSpec, Pundit, ActionCable, Geocoder (gratuito, via APIs livres) para geolocalização, Chartkick/Groupdate ou similar gratuito para gráficos.
 
---
 
## Restrições Globais
- Multi-tenancy: todo model relevante deve usar `include TenantScoped` (`company_id`).
- Segurança do Devise: nunca usar `none` nem sobrescrever finders do Devise.
- Porta do Postgres: 5433 (`fleetmaster_db`).
- NÃO FAZER COMMIT: o usuário instruiu explicitamente "só não deve fazer commit ainda".
- Testes: toda funcionalidade e toda página/tela deve ter testes RSpec (e, quando aplicável, teste de sistema/feature) comprovando que está funcionando — nenhuma tarefa é considerada concluída sem teste passando.
- Bibliotecas/APIs: priorizar bibliotecas e APIs gratuitas e funcionais (ex.: Geocoder, OpenStreetMap/Leaflet para mapas, Web Push/FCM gratuito para notificações). Somente migrar para serviço pago se necessário depois.
- Identidade visual: seguir o mockup e padrão visual já definidos no projeto; toda página nova deve respeitar esse padrão (cores, tipografia, componentes).
- Modo escuro: deve existir um botão de alternância de tema (claro/escuro) disponível em toda a aplicação web (e no app do motorista).
---
 
## Task 1: Migrations & Modelos de Domínio
- [ ] Migration para aprimorar `drivers` (`invitation_code`, `invitation_code_sent_at`, `invitation_code_expires_at`, `current_latitude`, `current_longitude`, `last_location_at`, `photo` via ActiveStorage, `fingerprint_enabled`)
- [ ] Migration e model `Client` (cliente/mercearia — nome, endereço padrão, contato, histórico de entregas)
- [ ] Migration e model `Vehicle` com foto (ActiveStorage), status (`disponível`, `em_rota`, `em_reparo`, `manutenção`), km atual, dados de documentação (CRLV, vencimento)
- [ ] Migration e model `Machinery` (máquina/equipamento — categoria, com/sem operador, valor hora, valor diária)
- [ ] Migration e model `MachineryRental` (locação — máquina, cliente, endereço de entrega, dias/horas, valor total calculado, status)
- [ ] Migration e model `Trip` (viagem — veículo, motorista, cliente, endereço de destino vinculado ao cliente mas editável, material transportado, status: `pendente`, `aceita`, `em_rota`, `entregue`, `não_entregue`, motivo de não entrega)
- [ ] Migration e model `TripStatusUpdate` (histórico de status da viagem, com fotos anexadas via ActiveStorage e motivo quando aplicável: acidente, quebra, falta de combustível, cliente ausente, outro)
- [ ] Migration e model `FuelRefuel` (abastecimento — veículo, motorista, km atual, litragem, valor, tipo de combustível, foto da nota fiscal)
- [ ] Migration e model `DriverLocation` (histórico de localização GPS do motorista/viagem)
- [ ] Migration e model `DriverNotification` (notificações push/in-app do motorista: nova viagem, CNH vencendo, etc.)
- [ ] Migration e model `Notification` (sininho de notificações do sistema web para secretários/admins: nova viagem, incidente, documento vencendo, abastecimento registrado)
- [ ] Migration e model `Plan` (planos de assinatura do sistema: nome, valor mensal, limites/recursos, dias de trial)
- [ ] Migration e model `Subscription` (assinatura da empresa cliente — plano, status: `trial`, `ativa`, `inadimplente`, `bloqueada`, `trial_ends_at`, `current_period_end`)
- [ ] Migration e model `AsaasCharge` (cobranças de assinatura via Asaas — vinculada à `Subscription`, não mais a uma tela avulsa)
- [ ] Rodar migrations em desenvolvimento e teste
- [ ] Testes: specs de model para validações, associações e enums de todos os models acima
## Task 2: Convite de Motorista por Código de E-mail e Criação de Senha
- [ ] Fluxo de pré-cadastro: secretário cria o motorista informando nome, CPF, telefone, e e-mail (do motorista, se tiver, ou da própria secretaria)
- [ ] `DriverInvitationMailer` envia código de 6 dígitos ao e-mail informado
- [ ] Model `Driver`: geração e verificação do código (com expiração)
- [ ] Endpoints API: `POST /api/v1/drivers/invitation/verify_code` e `POST /api/v1/drivers/invitation/set_password`
- [ ] Endpoints/telas web para reenvio de código pela secretaria, caso necessário
- [ ] Primeiro acesso no app: motorista informa o código recebido, valida, e então define sua própria senha e (opcionalmente) ativa login por impressão digital do celular
- [ ] Upload de foto de perfil do motorista no completar cadastro (exibida em toda a aplicação onde os dados do motorista aparecem)
- [ ] Testes: specs de geração/verificação de código, criação de senha, mailer, e teste de sistema do fluxo completo de primeiro acesso
## Task 3: API Mobile do Motorista — Escopo e Rastreamento de Localização
- [ ] `POST /api/v1/drivers/location` para rastreamento GPS ao vivo durante viagem em rota
- [ ] `GET /api/v1/drivers/trips` (viagem ativa) e `GET /api/v1/drivers/history` (histórico completo, listagem clicável com detalhe de cada viagem) — estritamente restrito ao motorista autenticado
- [ ] `GET /api/v1/drivers/vehicle` — dados e foto do veículo atualmente atribuído
- [ ] `POST /api/v1/drivers/trips/:id/accept` — motorista aceita a viagem recebida por notificação
- [ ] `PATCH /api/v1/drivers/trips/:id/status` — atualização de status (em rota, entregue, não entregue + motivo: acidente, quebra, falta de combustível, cliente ausente, outro) com upload de fotos
- [ ] `POST /api/v1/drivers/refuels` — registro de abastecimento (km atual, litragem, valor, tipo de combustível, foto da nota)
- [ ] Regra: motorista NUNCA pode alterar endereço/destino da viagem — apenas status e anexos
- [ ] `GET /api/v1/drivers/notifications` & `PATCH /api/v1/drivers/notifications/:id/read`
- [ ] `GET /api/v1/drivers/home_data` — localização, alertas (ex.: CNH vencendo), veículo, viagem ativa
- [ ] Push notification ao motorista quando: nova viagem atribuída (via seleção no sistema web), CNH próxima do vencimento, documento do veículo vencendo
- [ ] Testes: specs completos de todos os endpoints de API do motorista, incluindo casos de tentativa de acesso a dados de outro motorista (deve ser bloqueado)
## Task 4: Tabela de Veículos em Rota (Dashboard & Viagens)
- [ ] `DashboardController` e `TripsController` fornecendo dados ao vivo da frota em trânsito
- [ ] Tabela interativa em Tailwind com veículos em rota: motorista (com foto), veículo (com foto), cliente/destino, status da entrega, última coordenada GPS, horário estimado de entrega
- [ ] Clique na linha abre view de detalhe da viagem com: dados completos do motorista, do veículo, do material, e um **mapa** mostrando a localização em tempo real do motorista via GPS do celular (Leaflet + OpenStreetMap, gratuito)
- [ ] Fluxo de criação de viagem: selecionar veículo → selecionar motorista → selecionar cliente → destino pré-preenchido pelo endereço do cliente (editável) → ao salvar, motorista recebe notificação no app para aceitar
- [ ] Testes: specs de query de veículos em rota, renderização de view e do mapa, e fluxo de criação de viagem
## Task 5: Locação de Máquinas e Equipamentos
- [ ] `ClientsController` com CRUD completo e views
- [ ] `MachineriesController` com CRUD completo, categorias e taxas (por hora e por diária)
- [ ] `MachineryRentalsController`: criação de locação informando máquina, com ou sem operador, cliente, endereço de entrega do equipamento, quantidade de dias/horas, cálculo automático do valor total e atualização de status (`agendada`, `em_andamento`, `concluída`, `cancelada`)
- [ ] Controller Stimulus para cálculo dinâmico de preço (taxa horária vs. diária × duração), atualizado em tempo real no formulário
- [ ] Pundit policies para `Client`, `Machinery` e `MachineryRental`
- [ ] Testes: specs de models, controllers, policies e do cálculo dinâmico de preço
## Task 6: Planos de Assinatura do Sistema com Asaas (substitui a página avulsa de Cobranças)
- [ ] Remover a página "Cobranças & Faturamento Asaas" do sistema interno — cobrança via Asaas passa a existir **apenas** vinculada à assinatura do plano do sistema
- [ ] Landing page (já existente e funcional com link ativo) ganha seção de planos: 3 planos comerciais com preços e recursos, botão de contratação
- [ ] Fluxo de contratação: empresa se cadastra → recebe 15 dias de trial gratuito → ao final do trial, deve escolher plano e pagar via Asaas (PIX / Boleto / Cartão) para continuar
- [ ] Cobrança mensal recorrente por `Subscription`; se não pago, sistema bloqueia o acesso da empresa (tela de bloqueio com aviso e link para regularizar pagamento)
- [ ] `AsaasService`: criação de cliente, criação de assinatura/cobrança recorrente, verificação de status
- [ ] `Webhooks::AsaasController` para receber eventos de pagamento (confirmado, atrasado, cancelado) e atualizar `Subscription`
- [ ] Job periódico (Solid Queue) para checar trials expirando e assinaturas inadimplentes, bloqueando acesso quando necessário
- [ ] Base de cadastro pronta para quando a conta real do Asaas for criada (usar variáveis de ambiente/credenciais configuráveis, sandbox por padrão)
- [ ] Testes: specs com WebMock/stubs para `AsaasService`, processamento de webhook, bloqueio automático por trial expirado/inadimplência
## Task 7: Checker de Vencimento de Documentos & Sistema de Notificações
- [ ] `CheckExpiringDocumentsService` para alertas de CNH e manutenção/documentação de veículo
- [ ] Integração dos alertas nas notificações do app do motorista e no sininho de notificações do dashboard web (secretários/admins)
- [ ] Sininho de notificações no sistema web: contador de não lidas, dropdown com lista, marcação de lida, atualização em tempo real (ActionCable)
- [ ] Notificar o sistema web quando: novo incidente reportado pelo motorista, veículo precisa de reparo, documento vencendo, novo abastecimento registrado
- [ ] Testes: specs de detecção de vencimento e de entrega/leitura das notificações em ambos os lados (web e app)
## Task 8: Gestão de Frota — Status e Manutenção
- [ ] Tela de gestão de veículos com status detalhado (`disponível`, `em_rota`, `em_reparo`, `manutenção_preventiva`) e histórico de trocas/reparos por veículo
- [ ] Registro de manutenção (data, descrição, custo, peças trocadas)
- [ ] Gráficos (dashboard) de: veículos por status, viagens por período, faturamento de locações, abastecimentos por período/custo médio, incidentes por tipo
- [ ] Testes: specs de renderização dos gráficos e das telas de manutenção
## Task 9: Exportação Excel & PDF
- [ ] Exportação (CSV/Excel com BOM e layout PDF imprimível) para Viagens, Frota, Locações e Relatórios Financeiros
- [ ] Botões de exportação nas views de índice relevantes
- [ ] Testes: specs verificando a geração correta dos formatos de exportação
## Task 10: Modo Escuro
- [ ] Botão de alternância de tema (claro/escuro) fixo no layout, com persistência da preferência do usuário
- [ ] Ajuste de todas as telas (web) e telas do app do motorista ao padrão de cores dark, respeitando o padrão visual já definido
- [ ] Testes: teste de sistema garantindo que a alternância funciona e persiste entre sessões
## Task 11: Verificação Final do Sistema & Subida do Servidor
- [ ] Rodar toda a suíte de testes (`bundle exec rspec`) — todas as páginas e funcionalidades cobertas
- [ ] Subir servidor local na porta 3000
- [ ] Verificar endpoint de health check (`/up`)
- [ ] Checklist manual final: cadastro/edição de clientes, veículos, motoristas, máquinas; criação e acompanhamento de viagem ponta a ponta (web → notificação → app → aceite → status → entrega); locação de máquina com cálculo de preço; fluxo completo de trial → cobrança → bloqueio no Asaas; sininho de notificações; modo escuro; exportações