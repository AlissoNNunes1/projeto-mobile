# À LaCarte - Recomendações Inteligentes de Receitas

<p align="center">
  <img src="assets/images/logo.png" alt="À LaCarte Logo" width="200"/>
</p>

<p align="center">
  <a href="#sobre">Sobre</a> •
  <a href="#funcionalidades">Funcionalidades</a> •
  <a href="#tecnologias">Tecnologias</a> •
  <a href="#instalação">Instalação</a> •
  <a href="#uso">Uso</a> •
  <a href="#roadmap">Roadmap</a> •
  <a href="#contribuição">Contribuição</a> •
  <a href="#licença">Licença</a>
</p>

## Sobre

**À LaCarte** é um aplicativo móvel inovador que utiliza inteligência artificial para recomendar receitas personalizadas com base nos ingredientes disponíveis na sua cozinha, suas preferências pessoais e restrições alimentares. Desenvolvido com Flutter, o aplicativo proporciona uma experiência de usuário fluida e intuitiva em plataformas Android e iOS.

### Por que À LaCarte?

- **Reduza desperdício**: Utilize ingredientes que você já tem em casa
- **Descubra novas receitas**: Expandir seu repertório culinário
- **Personalização inteligente**: Recomendações que se adaptam ao seu gosto
- **Experiência sem complicações**: Inserção de ingredientes por texto, foto ou voz

## Funcionalidades

🧠 **Recomendações por IA**

- Sugestão inteligente de receitas com base em ingredientes disponíveis
- Personalização considerando histórico e preferências do usuário
- Adaptação às restrições alimentares

📸 **Múltiplas formas de entrada**

- Digitação de ingredientes com autocomplete
- Reconhecimento de ingredientes por foto
- Entrada de ingredientes por comando de voz

⭐ **Organização personalizada**

- Favoritos com organização por coleções
- Histórico de receitas visualizadas
- Listas de compras baseadas em receitas

🔄 **Uso online e offline**

- Acesso às receitas favoritas sem conexão
- Sincronização automática quando online
- Cache inteligente para melhorar performance

👤 **Perfil personalizado**

- Gerenciamento de preferências alimentares
- Histórico de receitas preparadas
- Estatísticas de uso e hábitos culinários

## Tecnologias

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase" alt="Firebase"/>
  <img src="https://img.shields.io/badge/AI-%23FF6F00.svg?style=for-the-badge&logo=TensorFlow&logoColor=white" alt="AI"/>
</p>

- **Frontend**: Flutter (cross-platform)
- **Backend**: Firebase (Auth, Firestore, Storage, Messaging)
- **IA**: API externa para recomendações e análise de imagens
- **Armazenamento local**: SQLite, SharedPreferences

## Instalação

### Pré-requisitos

- Flutter SDK (versão 3.10.0+)
- Dart SDK (versão 3.0.0+)
- Android Studio / Xcode
- Firebase CLI (opcional)

### Passos para instalação

1. Clone o repositório:

```bash
git clone https://github.com/seu-usuario/a-lacarte.git
cd a-lacarte
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Configure o Firebase:
   - Siga as instruções em [docs/setup.md](docs/setup.md#configuração-do-firebase)

4. Configure as variáveis de ambiente:
   - Crie um arquivo `.env` na raiz do projeto com as chaves necessárias

5. Execute o aplicativo:

```bash
flutter run
```

Para instruções mais detalhadas, consulte [docs/setup.md](docs/setup.md).

## Uso

### Primeira execução

1. Ao iniciar o aplicativo, você verá telas de onboarding explicando as funcionalidades
2. Crie uma conta ou entre com Google/Apple
3. Configure suas preferências alimentares e restrições
4. Na tela inicial, você já verá recomendações iniciais

### Fluxo básico

1. Adicione ingredientes por texto, foto ou voz
2. Visualize as receitas recomendadas
3. Selecione uma receita para ver os detalhes
4. Favorite, compartilhe ou adicione à sua lista de compras
5. Deixe uma avaliação após preparar a receita

Para guias mais detalhados de uso, consulte [a documentação do usuário](docs/user-guide.md).

## Roadmap

Veja nosso [roadmap detalhado aqui](docs/backlog/roadmap.md) para conhecer os próximos recursos planejados.

### Próximos passos

- [ ] Lista de compras automática
- [ ] Sistema de gamificação com conquistas
- [ ] Integração com assistentes de voz
- [ ] Receitas colaborativas
- [ ] Ajuste automático de porções

## Contribuição

Contribuições são bem-vindas! Para contribuir:

1. Leia nosso [guia de contribuição](docs/contributing.md)
2. Faça um fork do projeto
3. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
4. Commit suas alterações (`git commit -m 'Add some AmazingFeature'`)
5. Push para a branch (`git push origin feature/AmazingFeature`)
6. Abra um Pull Request

## Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

## Agradecimentos

- [Flutter](https://flutter.dev) por tornar o desenvolvimento cross-platform incrível
- [Firebase](https://firebase.google.com) pela infraestrutura de backend
- Todos os contribuidores que dedicaram tempo para melhorar este projeto

---

<p align="center">Feito com ❤️ pela equipe À LaCarte</p>
