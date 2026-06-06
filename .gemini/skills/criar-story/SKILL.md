---
name: criar-story
description: Cria ou edita histórias no Shortcut seguindo o padrão visual e de conteúdo do projeto FleetMaster Logistics. Garante o uso de Resumo Executivo, Direcionamento Técnico para IA e formatação rica com Markdown e Emojis. Use quando o usuário pedir para registrar uma tarefa, criar um ticket ou atualizar uma história existente no Shortcut.
---

# 📝 FleetMaster Criar Story

Esta skill orienta a criação e edição de histórias no Shortcut para o projeto FleetMaster Logistics, garantindo clareza para humanos e contexto técnico para IAs.

## 🛠️ Configurações do Shortcut
- **Time**: `Team 1` (ID: `6a170281-2a46-4926-964f-132fb651b1f2`)
- **Workflow**: `Standard` (ID: `500000005`)
- **Estado Inicial**: `To Do` (ID: `500000007`)
- **Owner**: Manter em **branco**, a menos que o usuário especifique alguém.

## ✍️ Padrão de Descrição (Markdown + Emojis)
Toda descrição deve ser visualmente leve, organizada e seguir esta estrutura obrigatória. ✨

### 1. Resumo Executivo 👨
Um parágrafo conciso voltado para humanos. Deve contextualizar:
- O que é o objetivo desta história?
- Por que ela existe?
- O que ela vai entregar de valor?

### 2. Detalhes Adicionais (Opcional) 📄
Informações complementares relevantes para o entendimento do negócio ou fluxo de trabalho. Use listas (`-`) para facilitar a leitura.

### 3. Direcionamento Técnico para IA 🤖
Um tópico final detalhado para que outra IA possa executar a tarefa com precisão. Deve incluir:
- Arquivos afetados (caminhos completos).
- Lógica esperada e regras de negócio.
- Sugestões de implementação e testes necessários.

## 🔄 Fluxo de Trabalho e Confirmações

### 🆕 Criando uma Nova História
1. **Autonomia**: Gere o "Resumo Executivo" e o "Direcionamento Técnico para IA" automaticamente com base na conversa atual.
2. **Pergunta Final**: Antes de chamar a ferramenta do Shortcut, pergunte ao usuário:
   > "Você já está satisfeito com o escopo ou deseja adicionar algo mais antes de eu criar a história no Shortcut? 🤔"

### ✏️ Editando uma História Existente
1. **Reformulação**: Se a descrição original não seguir o padrão, reescreva-a no formato novo.
2. **Segurança**: Antes de sobrescrever a descrição antiga, peça confirmação explícita:
   > "A descrição atual não segue o padrão FleetMaster. Posso reformulá-la inteira para incluir o Resumo Executivo e o Direcionamento IA? ⚠️"

## 🎨 Dicas de Estilo
- **Emojis**: Use emojis nos títulos e pontos principais (🚀, ✨, 🔴, 🟢).
- **Negrito**: Use para destacar nomes de classes, métodos ou termos chave.
- **Blocos de Código**: Utilize (```) para exemplos de implementação.
