# 📖 Meu Livro de Receitas

<div align="center">

**Um aplicativo mobile moderno para gerenciar suas receitas favoritas**

[![Flutter](https://img.shields.io/badge/Flutter-3.0.0+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0.0+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[Características](#-características) • [Tecnologias](#-tecnologias) • [Instalação](#-instalação) • [Configuração](#-configuração) • [Estrutura](#-estrutura-do-projeto)

</div>

---

## 📱 Sobre o Projeto

**Meu Livro de Receitas** é um aplicativo mobile desenvolvido em Flutter que permite aos usuários criar, organizar e gerenciar suas receitas culinárias de forma prática e intuitiva. Com uma interface moderna e amigável, o app oferece uma experiência completa para quem ama cozinhar.

### ✨ Características

#### 🔐 Autenticação Completa
- Cadastro de novos usuários com validação
- Login seguro com email e senha
- Gerenciamento de sessão com tokens JWT
- Armazenamento seguro de credenciais

#### 👨‍🍳 Gerenciamento de Receitas
- **Criação de receitas** com informações detalhadas:
  - Título da receita
  - Tempo de preparo (4 categorias: <10 min, 10-30 min, 30-60 min, >60 min)
  - Nível de dificuldade (Fácil, Médio, Difícil)
  - Múltiplos tipos de prato (Café da Manhã, Almoço, Entrada, Lanche, Sobremesa, Jantar, Bebidas)
  - Lista dinâmica de ingredientes
  - Instruções passo a passo numeradas
- Validação de formulário com mensagens intuitivas
- Detecção de alterações não salvas com confirmação
- Integração com backend (modo mock disponível para desenvolvimento)

#### 👤 Perfil do Usuário
- Visualização de informações do perfil
- Atualização de nome e email
- Alteração de senha
- Logout seguro

#### 🎨 Interface Moderna
- Design Material 3
- Tema customizado com cor primária coral (#FF6B35)
- Fonte Poppins em todo o aplicativo
- Componentes reutilizáveis e animados
- Experiência de usuário fluida e responsiva

---

## 🚀 Tecnologias

### Core
- **Flutter SDK 3.0.0+** - Framework multiplataforma
- **Dart 3.0.0+** - Linguagem de programação
- **Material Design 3** - Sistema de design moderno

### Gerenciamento de Estado
- **Provider 6.1.1** - Padrão ChangeNotifier para estado reativo

### Comunicação HTTP
- **http 1.1.0** - Cliente HTTP para requisições API
- **dio 5.4.0** - Cliente HTTP alternativo

### Armazenamento & Segurança
- **shared_preferences 2.2.2** - Armazenamento local
- **flutter_secure_storage 9.0.0** - Armazenamento seguro de tokens

### Navegação
- **go_router 16.2.5** - Roteamento declarativo moderno

### Formulários & Validação
- **flutter_form_builder 10.2.0** - Construtor de formulários
- **form_builder_validators 11.2.0** - Validadores pré-construídos

### UI & Estilização
- **google_fonts 6.1.0** - Fonte Poppins
- **cupertino_icons 1.0.6** - Ícones iOS

### Utilitários
- **intl 0.20.2** - Internacionalização
- **equatable 2.0.5** - Igualdade de valores

---

## 📦 Instalação

### Pré-requisitos

```bash
# Verifique se você tem Flutter instalado
flutter --version

# Recomendado: Flutter 3.0.0 ou superior
# Recomendado: Dart 3.0.0 ou superior
```

### Passos

1. **Clone o repositório**
```bash
git clone https://github.com/matheusbraga1/myrecipebook-frontend.git
cd myrecipebook-frontend
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o aplicativo**
```bash
# Android Emulator ou dispositivo conectado
flutter run

# iOS Simulator (apenas macOS)
flutter run -d ios
```

---

## ⚙️ Configuração

### Modo Mock vs API Real

O aplicativo suporta dois modos de operação:

#### 🎭 Modo Mock (Desenvolvimento)
Ideal para desenvolvimento e testes sem necessidade de backend.

**Ativar modo mock:**
```dart
// lib/config/app_config.dart
static const bool useMockData = true;
```

**Credenciais de teste:**
- Email: `teste@email.com`
- Senha: `123456`

**Características do modo mock:**
- Resposta instantânea sem dependência de rede
- Simulação de delay de rede (500-1000ms)
- Validação completa de dados
- Geração automática de IDs

#### 🌐 Modo API Real (Produção)
Conecta ao backend real para operações completas.

**Ativar modo API:**
```dart
// lib/config/app_config.dart
static const bool useMockData = false;
```

**Configurar URL da API:**
```dart
// lib/config/app_config.dart
static const String baseUrl = 'http://10.0.2.2:5016'; // Para Android Emulator
// ou
static const String baseUrl = 'http://localhost:5016'; // Para iOS Simulator
```

**Endpoints disponíveis:**
- `POST /user` - Registro de usuário
- `POST /login` - Login
- `POST /recipe` - Criar receita

---

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                          # Entrada do app, configuração de providers e tema
├── config/
│   └── app_config.dart                # Configurações (modo mock, URL da API)
├── constants/
│   └── strings.dart                   # Strings localizadas e textos da UI
├── models/                            # Modelos de dados com serialização JSON
│   ├── user.dart                      # User, AuthTokens, RegisteredUser
│   ├── recipe.dart                    # RegisterRecipeRequest, RegisteredRecipe
│   ├── recipe_enums.dart              # CookingTime, Difficulty, DishType
│   └── api_exception.dart             # Exceções customizadas
├── providers/                         # Gerenciamento de estado (Provider)
│   ├── auth_provider.dart             # Lógica de autenticação
│   ├── user_provider.dart             # Operações de perfil
│   └── recipe_provider.dart           # Operações de receitas
├── repositories/                      # Camada de acesso a dados
│   ├── auth_repository.dart           # Chamadas API de autenticação
│   ├── mock_auth_repository.dart      # Mock de autenticação
│   ├── user_repository.dart           # Chamadas API de usuário
│   ├── mock_user_repository.dart      # Mock de usuário
│   ├── recipe_repository.dart         # Chamadas API de receitas
│   └── mock_recipe_repository.dart    # Mock de receitas
├── services/                          # Serviços de baixo nível
│   ├── api_client.dart                # Cliente HTTP com tratamento de erros
│   └── storage_service.dart           # Persistência de tokens e dados
├── screens/                           # Telas do aplicativo
│   ├── auth/
│   │   ├── login_screen.dart          # Tela de login
│   │   └── register_screen.dart       # Tela de registro
│   ├── home/
│   │   └── home_screen.dart           # Tela principal
│   ├── profile/
│   │   ├── profile_screen.dart        # Visualizar/editar perfil
│   │   └── change_password_screen.dart # Alterar senha
│   └── recipe/
│       └── register_recipe_screen.dart # Cadastro de receita
└── widgets/                           # Componentes reutilizáveis
    ├── custom_text_field.dart         # Campo de texto estilizado
    ├── custom_button.dart             # Botão com estado de carregamento
    └── selectable_tag.dart            # Tag selecionável animada
```

### 🏗️ Arquitetura

O projeto segue princípios de **Clean Architecture** e **SOLID**:

- **Provider Pattern**: Gerenciamento de estado reativo
- **Repository Pattern**: Abstração da camada de dados
- **Service Layer**: Serviços de infraestrutura isolados
- **Separation of Concerns**: Separação clara entre UI, lógica e dados

---

## 🎯 Roadmap

### ✅ Implementado
- [x] Sistema completo de autenticação
- [x] Interface de perfil de usuário
- [x] Formulário completo de cadastro de receitas
- [x] Repositórios mock com simulação realista
- [x] Validação de formulários
- [x] Gerenciamento seguro de tokens

### 🚧 Em Desenvolvimento
- [ ] Busca e filtros de receitas
- [ ] Listagem de receitas

### 🔮 Planejado

- [ ] Imagens de receitas
- [ ] Tela de detalhes da receita
- [ ] Edição de receitas
- [ ] Integração completa com backend

---

## 🧪 Testes

```bash
# Executar todos os testes
flutter test

# Executar testes com coverage
flutter test --coverage
```

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

---

## 👤 Autor

Desenvolvido com ❤️ por Matheus Braga (bragadev)

---

<div align="center">

**[⬆ Voltar ao topo](#-meu-livro-de-receitas)**

</div>
