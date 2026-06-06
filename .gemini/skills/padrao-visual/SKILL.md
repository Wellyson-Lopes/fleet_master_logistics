---
name: padrao-visual
description: Garante que o desenvolvimento do frontend siga os padrões visuais do FleetMaster Logistics, baseando-se em mockups e respeitando as restrições técnicas de CSS/JS. Use ao criar ou alterar views, componentes ou estilos.
---

# 🎨 Padrão Visual FleetMaster Logistics

Este guia define as regras mandatórias para o desenvolvimento de interfaces no projeto, garantindo fidelidade aos mockups e uma arquitetura limpa.

## 🏛️ Diretrizes de Arquitetura Frontend

### 1. Estilização (CSS)
- **Framework**: Uso exclusivo de **Tailwind CSS** com **Flowbite**.
- **PROIBIÇÃO CRÍTICA**: Nunca usar estilos inline (`style="..."`).
- **Arquivos**: Se estilos customizados forem necessários, devem ser adicionados aos arquivos CSS em `app/assets/stylesheets/` usando a diretiva `@apply` do Tailwind quando possível.
- **CDNs**: É terminantemente proibido o uso de CDNs. Todos os assets (CSS, JS, Fontes, Imagens) devem ser servidos localmente pelo Rails.

### 2. Interatividade (JavaScript)
- **Padrão**: Uso exclusivo de **Hotwire** (Stimulus e Turbo).
- **PROIBIÇÃO CRÍTICA**: Nunca usar JavaScript inline (`<script>...</script>`) dentro de arquivos `.html.erb`.
- **Implementação**: Toda lógica client-side deve ser encapsulada em **Stimulus Controllers** (`app/javascript/controllers/`).

### 3. Fidelidade ao Design
- **Mockups**: Sempre consulte os mockups disponíveis no projeto (ex: `fleetmaster_design_system_mockup.html` ou arquivos em `app/views/home/`) para garantir a consistência visual.
- **Componentes**: Utilize componentes nativos do Flowbite adaptados para o projeto.

## 🔄 Fluxo de Desenvolvimento Visual

1. **Pesquisa**: Identifique o mockup correspondente à funcionalidade.
2. **Estrutura**: Crie o HTML usando as classes utilitárias do Tailwind.
3. **Estilo**: Verifique se não há estilos inline. Se precisar de algo complexo, use o arquivo CSS principal.
4. **Comportamento**: Se houver interatividade, crie um novo Stimulus Controller.
5. **Validação**: Verifique se nenhum asset externo (CDN) está sendo chamado.

## Checklist Final
- [ ] Interface é fiel ao mockup?
- [ ] ZERO estilos inline?
- [ ] ZERO JavaScript inline nas views?
- [ ] ZERO dependências de CDN?
- [ ] Lógica JS está em um Stimulus Controller?
- [ ] Tailwind/Flowbite utilizados corretamente?
