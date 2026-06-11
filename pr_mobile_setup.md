🎯 Objetivo
Inicializar o ecossistema mobile do FleetMaster e integrar o fluxo de autenticação JWT com o backend multi-tenant.

Story
Link: [https://app.shortcut.com/fleetmaster/story/43](https://app.shortcut.com/fleetmaster/story/43)

📋 Contexto
Este PR estabelece a base para o aplicativo móvel de motoristas. Foram configurados os padrões sênior de segurança e tipagem, garantindo que o App possa se comunicar de forma segura com o Rails através de tokens JWT, respeitando o isolamento por empresa.

🔧 Alterações Realizadas

### 📱 Mobile (React Native / Expo SDK 54)
- **Setup:** Inicialização do projeto com TypeScript e downgrade para SDK 54 para compatibilidade com dispositivos atuais.
- **Segurança:** Implementação de persistência de tokens via `expo-secure-store` (criptografia em hardware).
- **Rede:** Configuração do Axios com interceptores para injeção automática de tokens Bearer.
- **Estado:** Criação do `AuthContext` com tipagem forte para gestão global de autenticação.
- **UI:** Telas de Login e Home funcionais integradas à API.

### 🏗️ Backend (Rails 8)
- **Sessions:** Ajuste no `SessionsController` usando `unscoped` para permitir a localização do motorista durante o login multi-tenant.
- **Application:** Refatoração do `set_current_tenant` para evitar bloqueios de 401 em rotas públicas/autenticação.
- **Estilo:** Substituição de `Date.today` por `Date.current` no Dashboard conforme padrões de fuso horário do projeto.

✅ Comportamento Esperado
- O motorista consegue logar no App usando e-mail e senha.
- O token JWT é armazenado com segurança e persiste após o fechamento do App.
- O Rails identifica o motorista e aplica o isolamento de empresa automaticamente.
- Erros de login são genéricos para evitar enumeração de usuários.

🧪 Testes
- Validação manual do fluxo completo em dispositivo físico (Android/iOS).
- Verificação de logs de backend confirmando autenticação e definição de tenant.
- Compilação TypeScript (TSC) com zero erros.

✅ Checklist
- [x] Testes adicionados/atualizados
- [x] Código segue padrões (Linting OK)
- [x] Sem migrations destrutivas
- [x] Variáveis sensíveis protegidas
