# Product Backlog - À LaCarte

Este documento contém o backlog completo do produto, organizado por prioridade e categorizado por épicos e histórias de usuário.

## Épicos

1. **Core do Aplicativo**
2. **Autenticação e Perfil**
3. **Gerenciamento de Ingredientes**
4. **Recomendação de Receitas por IA**
5. **Favoritos e Histórico**
6. **Comentários e Avaliações**
7. **Recursos Offline**
8. **Notificações**
9. **Recursos Adicionais**

## Backlog Priorizado

### Épico 1: Core do Aplicativo

#### MVP (Alta Prioridade)

- [ ] **[CORE-1]** Criação da Splash Screen
- [ ] **[CORE-2]** Implementação das telas de Onboarding
- [ ] **[CORE-3]** Desenvolvimento da estrutura de navegação principal
- [ ] **[CORE-4]** Configuração do tema e estilos globais

### Épico 2: Autenticação e Perfil

#### MVP (Alta Prioridade)

- [ ] **[AUTH-1]** Implementar login com e-mail/senha
- [ ] **[AUTH-2]** Desenvolver tela de cadastro de novo usuário
- [ ] **[AUTH-3]** Tela de recuperação de senha
- [ ] **[AUTH-4]** Tela de perfil básico (visualização)

#### Incremental (Média Prioridade)

- [ ] **[AUTH-5]** Implementar login social (Google)
- [ ] **[AUTH-6]** Implementar login social (Apple)
- [ ] **[AUTH-7]** Adicionar edição de perfil completo
- [ ] **[AUTH-8]** Cadastro e gerenciamento de restrições alimentares

### Épico 3: Gerenciamento de Ingredientes

#### MVP (Alta Prioridade)

- [ ] **[ING-1]** Interface para inserção de ingredientes por texto
- [ ] **[ING-2]** Autocomplete na busca de ingredientes
- [ ] **[ING-3]** Lista de seleção de ingredientes para receita

#### Incremental (Média Prioridade)

- [ ] **[ING-4]** Reconhecimento de ingredientes por foto
- [ ] **[ING-5]** Reconhecimento de ingredientes por voz
- [ ] **[ING-6]** Organização de ingredientes por categorias
- [ ] **[ING-7]** Favoritar ingredientes frequentes

### Épico 4: Recomendação de Receitas por IA

#### MVP (Alta Prioridade)

- [ ] **[REC-1]** Integração com API de IA para recomendação básica
- [ ] **[REC-2]** Lista de receitas recomendadas baseadas nos ingredientes
- [ ] **[REC-3]** Visualização detalhada da receita (ingredientes e modo de preparo)
- [ ] **[REC-4]** Filtragem básica das recomendações (tempo de preparo, porções)

#### Incremental (Média Prioridade)

- [ ] **[REC-5]** Recomendação contextual (baseada no histórico)
- [ ] **[REC-6]** Filtros avançados (categorias, cozinhas específicas)
- [ ] **[REC-7]** IA considera restrições alimentares do usuário
- [ ] **[REC-8]** Sistema de feedback para melhorar recomendações futuras

### Épico 5: Favoritos e Histórico

#### MVP (Alta Prioridade)

- [ ] **[FAV-1]** Funcionalidade de favoritar receitas
- [ ] **[FAV-2]** Tela de receitas favoritas
- [ ] **[FAV-3]** Histórico de receitas visualizadas

#### Incremental (Média Prioridade)

- [ ] **[FAV-4]** Organização de favoritos por categorias personalizadas
- [ ] **[FAV-5]** Opção de marcar receitas como "preparadas"
- [ ] **[FAV-6]** Exportar/compartilhar lista de favoritos

### Épico 6: Comentários e Avaliações

#### Incremental (Média Prioridade)

- [ ] **[COM-1]** Sistema de avaliação de receitas (1-5 estrelas)
- [ ] **[COM-2]** Adição de comentários em receitas
- [ ] **[COM-3]** Visualização de comentários de outros usuários
- [ ] **[COM-4]** Moderação de comentários impróprios

### Épico 7: Recursos Offline

#### MVP (Alta Prioridade)

- [ ] **[OFF-1]** Armazenamento local das receitas favoritas
- [ ] **[OFF-2]** Acesso offline ao histórico recente

#### Incremental (Média Prioridade)

- [ ] **[OFF-3]** Cache de sugestões recentes
- [ ] **[OFF-4]** Sincronização automática quando online
- [ ] **[OFF-5]** Modo de economia de dados

### Épico 8: Notificações

#### Incremental (Baixa Prioridade)

- [ ] **[NOT-1]** Configuração de notificações push
- [ ] **[NOT-2]** Notificações de receitas sugeridas (diárias/semanais)
- [ ] **[NOT-3]** Lembretes personalizados
- [ ] **[NOT-4]** Notificações de novos recursos

### Épico 9: Recursos Adicionais

#### Futuro (Baixa Prioridade)

- [ ] **[EXTRA-1]** Lista de compras baseada em receitas
- [ ] **[EXTRA-2]** Receitas colaborativas com outros usuários
- [ ] **[EXTRA-3]** Sistema de gamificação com conquistas culinárias
- [ ] **[EXTRA-4]** Integração com assistentes de voz
- [ ] **[EXTRA-5]** Modo de conversa com IA para receitas personalizadas
- [ ] **[EXTRA-6]** Ajuste de porções e conversão de unidades
- [ ] **[EXTRA-7]** Calculadora nutricional

## Critérios de Priorização

- **MVP (Alta)**: Funcionalidades essenciais para o lançamento inicial
- **Incremental (Média)**: Recursos importantes para segunda versão
- **Futuro (Baixa)**: Melhorias a serem desenvolvidas em versões futuras

## Métricas de Aceitação

Cada item do backlog deve satisfazer os seguintes critérios:

1. Todos os testes unitários passam
2. Código revisado por pelo menos um desenvolvedor
3. Interface de usuário segue o guia de estilo do projeto
4. Requisitos funcionais verificados manualmente
5. Não apresenta problemas de performance óbvios
