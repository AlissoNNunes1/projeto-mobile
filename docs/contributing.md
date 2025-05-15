# Guia de Contribuição - À LaCarte

Obrigado pelo interesse em contribuir com o projeto À LaCarte! Este documento fornece diretrizes para contribuição, incluindo padrões de código, fluxo de trabalho e boas práticas.

## Índice

1. [Código de Conduta](#código-de-conduta)
2. [Como Posso Contribuir?](#como-posso-contribuir)
3. [Configuração do Ambiente](#configuração-do-ambiente)
4. [Padrões de Código](#padrões-de-código)
5. [Processo de Contribuição](#processo-de-contribuição)
6. [Estrutura do Projeto](#estrutura-do-projeto)
7. [Testes](#testes)
8. [Revisão de Código](#revisão-de-código)
9. [Recursos Adicionais](#recursos-adicionais)

## Código de Conduta

Este projeto segue um Código de Conduta para criar um ambiente acolhedor e inclusivo. Ao contribuir, você concorda em respeitar estes princípios:

- Usar linguagem acolhedora e inclusiva
- Respeitar diferentes pontos de vista e experiências
- Aceitar críticas construtivas graciosamente
- Focar no que é melhor para a comunidade
- Mostrar empatia para com outros membros da comunidade

## Como Posso Contribuir?

### Reportar Bugs

- Verifique se o bug já não foi reportado
- Use o template de issue para bug
- Inclua passos detalhados para reprodução
- Descreva o comportamento esperado vs. atual
- Inclua screenshots se relevante

### Sugerir Melhorias

- Explique claramente a melhoria
- Forneça exemplos de uso e benefícios
- Considere o escopo do projeto

### Pull Requests

- Crie um fork do repositório
- Crie uma branch para sua feature/correção
- Siga os padrões de código
- Inclua testes adequados
- Atualize a documentação se necessário

## Configuração do Ambiente

Consulte o arquivo [setup.md](./setup.md) para instruções detalhadas sobre a configuração do ambiente de desenvolvimento.

## Padrões de Código

### Estilo de Código Dart/Flutter

Seguimos o [Effective Dart](https://dart.dev/guides/language/effective-dart) para a formatação e estilo de código.

```bash
# Formatar código automaticamente
flutter format .

# Analisar código em busca de problemas
flutter analyze
```

### Convenções de Nomenclatura

- **Classes**: PascalCase (ex: `RecipeRepository`)
- **Variáveis e métodos**: camelCase (ex: `getUserProfile()`)
- **Constantes**: kCamelCase ou SCREAMING_SNAKE_CASE (ex: `kDefaultPadding` ou `MAX_RETRY_COUNT`)
- **Arquivos**: snake_case.dart (ex: `recipe_repository.dart`)
- **Pastas**: snake_case (ex: `data_sources`)

### Estrutura de Classes e Arquivos

- Uma classe principal por arquivo
- Organizar métodos em ordem lógica
- Agrupar métodos relacionados
- Comentar seções complexas
- Manter arquivos abaixo de 300 linhas quando possível

### Documentação

- Documentar classes públicas e métodos com comentários de documentação `///`
- Explicar argumentos complexos e valores de retorno
- Incluir exemplos para APIs públicas
- Manter READMEs atualizados

## Processo de Contribuição

### Fluxo de Trabalho Git

1. **Branches**:
   - `main`: Código estável de produção
   - `develop`: Branch de desenvolvimento
   - `feature/*`: Para novas funcionalidades
   - `bugfix/*`: Para correção de bugs
   - `release/*`: Para preparação de releases
   - `hotfix/*`: Para correções urgentes em produção

2. **Processo para contribuições**:
   - Crie um fork do repositório
   - Clone seu fork: `git clone https://github.com/seu-usuario/a-lacarte.git`
   - Adicione o upstream: `git remote add upstream https://github.com/repo-original/a-lacarte.git`
   - Crie uma branch a partir de `develop`: `git checkout -b feature/sua-feature`
   - Faça as alterações, adicione commits
   - Push para seu fork: `git push origin feature/sua-feature`
   - Abra um Pull Request para a branch `develop`

### Mensagens de Commit

Usamos o padrão [Conventional Commits](https://www.conventionalcommits.org/):

```
<tipo>[escopo opcional]: <descrição>

[corpo opcional]

[rodapé opcional]
```

**Tipos**:

- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Alterações em documentação
- `style`: Formatação, ponto-e-vírgula, etc; sem mudança de código
- `refactor`: Refatoração de código
- `perf`: Melhorias de performance
- `test`: Adicionando ou corrigindo testes
- `chore`: Alterações em processos de build, ferramentas, etc.

**Exemplo**:

```
feat(ingredient): adicionar reconhecimento de imagem

Implementa a capacidade de reconhecer ingredientes a partir de imagens
usando a API de visão computacional.

Resolve: #123
```

### Pull Requests

- Título claro e descritivo
- Descrição detalhada das alterações
- Referência a issues relacionadas: "Resolve #123"
- Aguarde revisão de pelo menos um mantenedor
- Resolva qualquer feedback da revisão

## Estrutura do Projeto

Para entender a estrutura organizacional do código, consulte a seção [Estrutura do Projeto](./setup.md#estrutura-do-projeto) no guia de configuração.

## Testes

### Tipos de Testes

- **Testes unitários**: Para lógica de negócios e funções isoladas
- **Testes de Widget**: Para componentes de UI
- **Testes de integração**: Para fluxos completos

### Escrevendo Testes

```dart
// Exemplo de teste unitário
void main() {
  group('RecipeService', () {
    late RecipeService service;
    late MockRecipeRepository mockRepository;
    
    setUp(() {
      mockRepository = MockRecipeRepository();
      service = RecipeService(repository: mockRepository);
    });
    
    test('deve retornar lista de receitas quando chamado com sucesso', () async {
      // Arrange
      when(mockRepository.getRecipes()).thenAnswer((_) async => 
        Right<Failure, List<Recipe>>([
          Recipe(id: '1', title: 'Teste', ingredients: [])
        ])
      );
      
      // Act
      final result = await service.getRecipes();
      
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Não deveria falhar'),
        (r) => expect(r.length, 1)
      );
      verify(mockRepository.getRecipes()).called(1);
    });
  });
}
```

### Executando Testes

```bash
# Executar todos os testes
flutter test

# Executar teste específico
flutter test test/path/to/test.dart

# Executar com cobertura
flutter test --coverage
```

## Revisão de Código

### Processo de Revisão

1. Outro desenvolvedor revisará seu código
2. Feedback será fornecido como comentários no PR
3. Faça as alterações solicitadas
4. Responda aos comentários
5. Aguarde aprovação final

### Critérios de Revisão

- **Funcionalmente Correto**: Implementa corretamente a funcionalidade
- **Seguro**: Não introduz vulnerabilidades
- **Testado**: Inclui testes adequados
- **Legível**: Código claro e bem documentado
- **Performático**: Não causa regressões de performance
- **Manutenível**: Segue os padrões do projeto
- **Compatível**: Funciona em todas as plataformas suportadas

## Recursos Adicionais

- [Documentação do Flutter](https://flutter.dev/docs)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Clean Code em Flutter](https://github.com/ResoCoder/flutter-clean-architecture-course)
- [Flutter Testing](https://docs.flutter.dev/testing)

## Agradecimento

Obrigado por dedicar seu tempo para contribuir com o À LaCarte! Sua contribuição torna este projeto melhor para todos.

---

*Este guia de contribuição é um documento vivo. Sugestões para melhorá-lo são bem-vindas!*
