# Diretrizes de Interface - À LaCarte

Este documento define os padrões de design, componentes e estilo visual para o aplicativo À LaCarte.

## 🎨 Paleta de Cores

### Cores Principais

- **Verde Principal:** `324C3F`
  - Uso: Elementos principais, botões de confirmação, destacar ação principal
  
- **Branco/Off-White:** `#FDFDFD`
  - Uso: Fundos, áreas de conteúdo, espaços neutros
  
- **Cinza Escuro:** `#333333`
  - Uso: Textos, ícones, elementos secundários
  
- **Amarelo/Dourado:** `CDBA5B`
  - Uso: Destaques, call-to-action, estrelas de avaliação

### Cores de Apoio

- **Verde Claro:** `#5EBD93` (variação mais clara do verde principal)
  - Uso: Hover states, elementos secundários
  
- **Cinza Claro:** `#E0E0E0`
  - Uso: Divisores, bordas, elementos inativos
  
- **Vermelho:** `#FF4136`
  - Uso: Alertas, notificações importantes, erros

## 🔤 Tipografia

### Família de Fonte

**Poppins** é a fonte principal do aplicativo.

### Hierarquia de Texto

- **Título Principal:** Poppins Bold, 24sp
- **Título Secundário:** Poppins SemiBold, 20sp
- **Título de Card:** Poppins Medium, 18sp
- **Subtítulo:** Poppins Medium, 16sp
- **Corpo de Texto:** Poppins Regular, 14sp
- **Texto Pequeno:** Poppins Regular, 12sp
- **Caption/Legenda:** Poppins Light, 10sp

### Exemplos de Uso

```dart
// Título principal
Text(
  'Receitas Sugeridas',
  style: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: Color(0xFF333333),
  ),
),

// Corpo de texto
Text(
  'Confira estas receitas baseadas nos seus ingredientes.',
  style: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: Color(0xFF333333),
  ),
),
```

## 🧩 Componentes de UI

### Botões

#### Botão Primário

- Fundo: Verde Principal (`#3D9970`)
- Texto: Branco (`#FDFDFD`)
- Altura: 48dp
- Cantos: Arredondados (raio 8dp)
- Estado hover/pressionado: Verde Claro (`#5EBD93`)

#### Botão Secundário

- Borda: Cinza Escuro (`#333333`)
- Texto: Cinza Escuro (`#333333`)
- Fundo: Transparente
- Altura: 48dp
- Cantos: Arredondados (raio 8dp)

#### Botão de Ícone

- Ícone: Cinza Escuro (`#333333`)
- Fundo: Transparente
- Tamanho: 40dp x 40dp
- Estado ativo: Círculo de fundo cinza claro

### Cards

#### Card de Receita

- Fundo: Branco (`#FDFDFD`)
- Sombra: leve (elevation: 2)
- Cantos: Arredondados (raio 12dp)
- Imagem superior com proporção 16:9
- Padding interno: 16dp

#### Card de Ingrediente

- Fundo: Branco (`#FDFDFD`)
- Borda: Cinza Claro (`#E0E0E0`)
- Cantos: Arredondados (raio 8dp)
- Altura: 56dp
- Ícone à esquerda, texto ao centro

### Input Fields

#### Campo de Texto Padrão

- Borda: Cinza Claro (`#E0E0E0`)
- Texto: Cinza Escuro (`#333333`)
- Altura: 56dp
- Estado focus: Borda verde principal
- Padding horizontal: 16dp

#### Campo de Busca

- Ícone de lupa à esquerda
- Fundo: Branco com borda
- Cantos arredondados
- Placeholder em cinza claro

### Navegação

#### Bottom Navigation Bar

- Itens: Home, Favoritos, Histórico, Perfil
- Ícone e texto
- Item ativo: Verde Principal
- Item inativo: Cinza Escuro

#### AppBar

- Fundo: Branco (`#FDFDFD`)
- Título: Cinza Escuro (`#333333`)
- Altura: 56dp
- Sombra sutil

## 📏 Espaçamento

### Sistema de Grid

- Margem de tela: 16dp
- Espaçamento entre cards: 12dp
- Espaçamento entre seções: 24dp
- Espaçamento entre elementos relacionados: 8dp

### Padding

- Padding padrão interno de containers: 16dp
- Padding entre ícone e texto: 8dp
- Padding entre títulos e conteúdo: 12dp

## 🖼️ Imagens e Ícones

### Imagens

- Receitas: Proporção 16:9
- Ingredientes: Proporção 1:1 (quadrada)
- Avatares: Circulares

### Ícones

- Sistema de ícones: Material Icons
- Tamanho padrão: 24dp
- Cor padrão: Cinza Escuro (`#333333`)
- Ícones interativos: Verde Principal quando ativos

## 🔄 Animações e Transições

- Transições entre telas: Fade em conjunto com slide
- Duração padrão: 300ms
- Curva de animação: ease-in-out
- Loading indicators: Circular com cores da marca

## 📱 Responsividade

- Design mobile-first
- Breakpoints adaptáveis:
  - Smartphones (360dp - 480dp)
  - Smartphones grandes (480dp - 600dp)
  - Tablets pequenos (600dp - 720dp)
  - Tablets (720dp+)

## ♿ Acessibilidade

- Contraste mínimo para texto: 4.5:1
- Tamanho mínimo de alvo touch: 48dp x 48dp
- Espaçamento mínimo entre elementos tocáveis: 8dp
- Todos elementos interativos devem ter descrições para leitores de tela
- Feedback visual e tátil para todas ações

## 📝 Exemplos de Implementação

```dart
// Tema global para o aplicativo
ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFF3D9970),
  accentColor: Color(0xFFE1AD01),
  backgroundColor: Color(0xFFFDFDFD),
  fontFamily: 'Poppins',
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
    headline2: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    bodyText1: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xFF333333)),
    bodyText2: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xFF333333)),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF3D9970),
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
```
