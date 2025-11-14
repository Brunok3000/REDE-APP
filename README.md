# REDE App — Flutter Super App Marketplace# 🚀 REDE - Superapp Flutter + Supabase



![Flutter](https://img.shields.io/badge/Flutter-3.9-blue?logo=flutter)## 📌 COMECE AQUI

![Dart](https://img.shields.io/badge/Dart-3.9-blue?logo=dart)

![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green?logo=supabase)> ⚡ **Primeiro uso? Siga:** [`CHECKLIST_IMEDIATO.md`](CHECKLIST_IMEDIATO.md) (15 minutos)

![License](https://img.shields.io/badge/License-MIT-blue)

---

**REDE** é um super app Flutter multiplataforma (Web, iOS, Android) que funciona como marketplace para estabelecimentos (restaurantes, bares, hotéis, fornecedores de eventos). Código pronto para clone, customização e deploy.

## 📚 Documentação Completa

## 🎯 Features Implementadas

| Documento | Para quê |

### Auth & User Management|---|---|

- ✅ Login/Registro com email/senha| **[CHECKLIST_IMEDIATO.md](CHECKLIST_IMEDIATO.md)** | ✨ **COMECE AQUI** — 3 passos para rodar em 15 min |

- ✅ Google Sign-In| **[RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md)** | 📊 O que foi feito, status atual, próximos passos |

- ✅ Role-based access (consumer vs partner)| **[PROJECT_STATUS.md](PROJECT_STATUS.md)** | 📋 Status técnico completo + estrutura do projeto |

- ✅ Profile management com Supabase Auth + Realtime| **[QUICK_START.md](QUICK_START.md)** | 🏃 Guia rápido — Setup, run, troubleshooting |

| **[SUPABASE_CONFIG.md](SUPABASE_CONFIG.md)** | 🔧 Configuração Supabase — URLs, chaves, credenciais |

### Consumer Features| **[GUIA_DEPLOY.md](GUIA_DEPLOY.md)** | 🚀 Como aplicar migrations, seed, functions |

- ✅ Feed com posts (realtime + infinite scroll)| **[prompts.md](prompts.md)** | 📝 Lista de tarefas do projeto (14 passos) |

- ✅ Search de estabelecimentos (filtros: tipo, geo, B2B)

- ✅ Discover eventos/estabelecimentos próximos (geolocalização)---

- ✅ Menu & Carrinho (persistent via Riverpod)

- ✅ Checkout com inserção de ordem## 🎯 Configuração Rápida

- ✅ Histórico de pedidos

- ✅ Reservas, ingressos, hospedagem (booking UI)### 1. Aplicar Seed (5 min)

Abra: https://app.supabase.com/project/chyhjtbgzwwdckhptnja/sql/new  

### Partner Features  Cole: `supabase/seed/mock_data.sql` → Clique **Run**

- ✅ POS Dashboard (realtime orders, KDS)

- ✅ Gerenciamento de pedidos (abas por status)### 2. Testar App (10 min)

- ✅ Hive local caching (offline-first)```bash

- ✅ Notificações de novo pedido (vibra + som + toast)cd rede

flutter pub get

### Backend & Notificationsflutter run -d chrome

- ✅ Server-side outbox pattern (migration + trigger)```

- ✅ Edge Function para envio FCM

- ✅ Firebase Cloud Messaging integrado### 3. Continuar Desenvolvimento

- ✅ GitHub Actions workflow para deploy automáticoAbra `prompts.md` para próximas tarefas (14 passos total)



## 📁 Estrutura do Projeto---



```## 📦 Tecnologias

lib/

├── main.dart                    # App init, routing, Firebase setup- **Frontend:** Flutter 3.x + Riverpod 2 + GoRouter

├── config/- **Backend:** Supabase (PostgreSQL + PostGIS)

│   └── env.dart                 # Variáveis de ambiente- **Real-time:** Supabase Realtime + Edge Functions

├── models/                      # User, Order, Post, etc (fromJson/toJson)- **Notificações:** Firebase Cloud Messaging

├── services/- **POS:** esc_pos_bluetooth (print receipt)

│   ├── supabase_client.dart     # Supabase singleton + helpers- **Mapas:** Google Maps Flutter

│   └── geo_service.dart         # Geolocalização- **State:** Flutter Riverpod

├── providers/                   # Riverpod state management- **Navigation:** GoRouter

│   ├── auth/

│   ├── cart/---

│   ├── location/

│   └── role/## 📂 Estrutura do Projeto

└── screens/                     # Telas por feature

    ├── auth/```

    ├── feed/REDE/

    ├── search/├── rede/                         # App Flutter

    ├── discover/│   ├── lib/

    ├── orders/│   │   ├── main.dart            # Entrypoint

    ├── partner/│   │   ├── config/env.dart      # Supabase URLs

    └── settings/│   │   ├── services/            # Supabase client

│   │   ├── providers/           # Riverpod state

supabase/│   │   ├── screens/             # Telas do app

├── migrations/                  # SQL migrations (schema + RLS)│   │   └── widgets/             # Componentes

└── functions/│   └── pubspec.yaml             # Dependências

    └── new_order_notification/  # Edge Function (FCM)│

├── supabase/                     # Backend

.github/│   ├── migrations/              # Schema SQL

└── workflows/│   ├── seed/                    # Dados exemplo

    └── deploy-supabase-function.yml  # CI/CD para deploy automático│   ├── functions/               # Edge Functions

```│   └── config.toml              # Supabase config

│

## 🚀 Setup Rápido (5 min)└── [Documentação]

    ├── README.md

### Pré-requisitos    ├── CHECKLIST_IMEDIATO.md

- Flutter 3.9+ (`flutter --version`)    ├── PROJECT_STATUS.md

- Supabase account & project (https://supabase.com)    ├── GUIA_DEPLOY.md

- Firebase project (opcional, para FCM)    ├── prompts.md

    └── ...

### 1. Clone e instale dependências```

```bash

git clone https://github.com/Brunok3000/REDE-APP.git---

cd REDE-APP

flutter pub get## 🔐 Segurança

```

⚠️ **NUNCA COMMITAR:**

### 2. Configure Supabase- `.env.local` — Credenciais sensíveis

- Crie um projeto em https://supabase.com- `SERVICE_ROLE_KEY` — Backend only

- Vá em **SQL Editor** → copie/cole `supabase/migrations/` para seu projeto- Senhas do banco

- Configure `lib/config/env.dart`:

  ```dart✅ **ARQUIVOS IMPORTANTES:**

  const SUPABASE_URL = 'https://seu-projeto.supabase.co';- `supabase/migrations/` — Schema controle de versão

  const SUPABASE_ANON_KEY = 'sua-anon-key';- `supabase/seed/` — Dados de exemplo

  ```- `supabase/functions/` — Edge Functions code

- `prompts.md` — Tarefas do projeto

### 3. Configure Firebase (opcional, necessário para FCM)

- Vá em https://firebase.google.com---

- Configure Google Cloud Messaging (FCM)

- Baixe credenciais e configure no projeto## ⚙️ CI/CD com GitHub Actions



### 4. Rode a appO projeto inclui workflow automático para deploy:

```bash- **Arquivo:** `.github/workflows/supabase-seed-deploy.yml`

# Web- **Acionado:** Push para `main` ou alterações em `supabase/seed/` ou `supabase/functions/`

flutter run -d chrome- **O que faz:** Aplica migrations, seed, e deploy de Edge Functions



# Android emulator**Configuração necessária:** Veja [`.github/SECRETS_SETUP.md`](.github/SECRETS_SETUP.md)

flutter run -d emulator-5554

---

# iOS simulator

flutter run -d simulator## 🚀 Próximos Passos

```

1. **Hoje:** Aplique seed e rode `flutter run`

## 🔧 Configuração de Deployment (CI/CD)2. **GitHub:** Configure secrets em Settings (veja `.github/SECRETS_SETUP.md`)

3. **Passo 4:** Melhorar Auth Screens (conforme prompts.md)

Inclui GitHub Actions workflow para deploy automático.4. **Passo 5+:** Implementar features (feed, search, orders, etc)

5. **Final:** Deploy (web + mobile)

### 1. Adicione Secrets ao GitHub

```bashConsulte `prompts.md` para a sequência completa (14 passos).

gh secret set SUPABASE_TOKEN --body "seu-token"

gh secret set SUPABASE_PROJECT_REF --body "seu-project-ref"---

gh secret set SUPABASE_URL --body "https://seu-projeto.supabase.co"

gh secret set SUPABASE_SERVICE_ROLE_KEY --body "sua-service-role-key"## 📞 Ajuda

gh secret set FCM_SERVER_KEY --body "sua-fcm-server-key"

```- 📖 [Supabase Docs](https://supabase.com/docs)

- 🦋 [Flutter Docs](https://flutter.dev/docs)

### 2. Deploy Edge Function- 🏗️ [Riverpod Docs](https://riverpod.dev)

```bash- 🗺️ [Google Maps API](https://developers.google.com/maps)

# Automático: Push em supabase/functions/* 

# Ou disparar manualmente em GitHub → Actions---

```

**Status:** ✅ Fase 1-2 Completa | ⏳ Fase 3+ em Progresso  

## 📊 Stack Técnico**Data:** 14 de novembro de 2025  

**Próxima ação:** Leia [`CHECKLIST_IMEDIATO.md`](CHECKLIST_IMEDIATO.md)

| Camada | Tecnologia | 

|--------|-----------|## Cloud (production)

| Frontend | Flutter 3.9 + Dart |

| State | Riverpod (type-safe) |1. Use a mesma pasta `supabase/migrations` e aplique as migrations pelo Supabase CLI vinculando seu projeto remoto:

| Routing | GoRouter |

| Backend | Supabase (PostgreSQL + RLS) |```powershell

| Realtime | Supabase Realtime + Edge Functions |supabase link --project-ref <PROJECT_REF>

| Notificações | Firebase Cloud Messaging |supabase db push

| Local Storage | Hive (offline-first) |```

| UI | Material 3 + custom widgets |

2. Para a função de notificação `new_order_notification` use as Edge Functions do Supabase:

## 🔐 Segurança

- Deploy: `supabase functions deploy new_order_notification --project-ref <PROJECT_REF>`

- **RLS:** Habilitado em todas as tabelas- Configure variáveis de ambiente da função: `SUPABASE_SERVICE_ROLE_KEY` e `FCM_SERVER_KEY` no painel de funções.

- **Auth:** Supabase Auth com JWT

- **Secrets:** GitHub Secrets (nunca .env)## Observações

- **API:** Service Role Key apenas em CI/Functions

- Eu adicionei uma trigger `notify_new_order` que usa `pg_notify('new_order', payload)` — isso permite integrar Realtime ou criar um evento de DB no painel do Supabase que chame sua Edge Function. Se você preferir que o trigger invoque diretamente a Edge Function via HTTP, crie um Database trigger no Dashboard que aponte para a função HTTP `https://<PROJECT>.functions.supabase.co/new_order_notification`.

## 🧪 Testes- Arquivos criados: `supabase/migrations/001_full_schema.sql`, `supabase/seed/mock_data.sql`, `supabase/functions/new_order_notification/index.ts`, `.env` (exemplo), `supabase/.supabase/config.toml`.


```bash
# Análise
flutter analyze

# Testes
flutter test

# Build release
flutter build web --release
```

## 📚 Documentação

- [Supabase Docs](https://supabase.com/docs)
- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod](https://riverpod.dev)
- [GoRouter](https://pub.dev/packages/go_router)

## 📄 License

MIT — Veja LICENSE

---

**Desenvolvido com ❤️ usando Flutter + Supabase**
