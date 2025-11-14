# REDE App � Flutter Superapp Marketplace

![Flutter](https://img.shields.io/badge/Flutter-3.9-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9-blue?logo=dart)
![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green?logo=supabase)
![License](https://img.shields.io/badge/License-MIT-blue)

REDE � um superapp Flutter multiplataforma (Web, iOS, Android) que funciona como marketplace para estabelecimentos (restaurantes, bares, hot�is, fornecedores de eventos). Este reposit�rio cont�m o c�digo-fonte, migrations e fun��es de backend (Supabase).

## Comece rapidamente

1. Clone o reposit�rio

```powershell
git clone https://github.com/Brunok3000/REDE-APP.git
cd REDE-APP
flutter pub get
```

1. Aplicar migrations (ver `SUPABASE_MIGRATIONS_GUIDE.md`) e configure as variáveis de ambiente em `lib/config/env.dart`.

2. Rodar em web (Chrome):

```powershell
flutter run -d chrome
```

## 📚 Estrutura de Diretórios

```txt
lib/
+-- config/env.dart          # Vari�veis de ambiente
+-- services/
�   +-- supabase_client.dart # Singleton Supabase
�   +-- geo_service.dart     # Geolocaliza��o
+-- models/                  # Modelos com fromJson/toJson
+-- providers/               # Riverpod state management
�   +-- auth/
�   +-- cart/
�   +-- location/
�   +-- role/
+-- screens/                 # Telas da aplica��o
    +-- auth/
    +-- feed/
    +-- search/
    +-- discover/
    +-- orders/
    +-- settings/

supabase/
+-- migrations/              # Schema + migrations SQL
+-- functions/               # Edge Functions (TypeScript)
+-- seed/                    # Mock data
```

## ?? Tech Stack

- **Frontend:** Flutter 3.9.2 + Dart 3.9
- **State Management:** Riverpod 2
- **Routing:** GoRouter
- **Backend:** Supabase (PostgreSQL + RLS + PostGIS)
- **Notifica��es:** Firebase Cloud Messaging (FCM)
- **Cache Local:** Hive

## ?? Deployment

### Aplicar Migrations (Local)

Ver `SUPABASE_MIGRATIONS_GUIDE.md` para instru��es completas.

### Build Web

```powershell
flutter build web --release
```

### Build APK (Android)

```powershell
flutter build apk --release
```

## ?? Documenta��o

- **Arquitetura e Padr�es:** [.github/copilot-instructions.md](.github/copilot-instructions.md)
- **Guia de Migrations:** [SUPABASE_MIGRATIONS_GUIDE.md](SUPABASE_MIGRATIONS_GUIDE.md)
- **Prompts de Desenvolvimento:** [prompts.md](prompts.md)

## ?? Testes

```powershell
flutter test
```

## ?? Vari�veis de Ambiente

Configure em `lib/config/env.dart`:

```dart
const String SUPABASE_URL = 'https://your-project.supabase.co';
const String SUPABASE_ANON_KEY = 'your-anon-key';
```

## ?? License

MIT License � ver LICENSE para detalhes.

---

**Maintainer:** [Brunok3000](https://github.com/Brunok3000)

**Data:** Novembro 2025
