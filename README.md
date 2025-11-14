# 🚀 REDE - Superapp Flutter + Supabase

## 📌 COMECE AQUI

> ⚡ **Primeiro uso? Siga:** [`CHECKLIST_IMEDIATO.md`](CHECKLIST_IMEDIATO.md) (15 minutos)

---

## 📚 Documentação Completa

| Documento | Para quê |
|---|---|
| **[CHECKLIST_IMEDIATO.md](CHECKLIST_IMEDIATO.md)** | ✨ **COMECE AQUI** — 3 passos para rodar em 15 min |
| **[RESUMO_EXECUTIVO.md](RESUMO_EXECUTIVO.md)** | 📊 O que foi feito, status atual, próximos passos |
| **[PROJECT_STATUS.md](PROJECT_STATUS.md)** | 📋 Status técnico completo + estrutura do projeto |
| **[QUICK_START.md](QUICK_START.md)** | 🏃 Guia rápido — Setup, run, troubleshooting |
| **[SUPABASE_CONFIG.md](SUPABASE_CONFIG.md)** | 🔧 Configuração Supabase — URLs, chaves, credenciais |
| **[GUIA_DEPLOY.md](GUIA_DEPLOY.md)** | 🚀 Como aplicar migrations, seed, functions |
| **[prompts.md](prompts.md)** | 📝 Lista de tarefas do projeto (14 passos) |

---

## 🎯 Configuração Rápida

### 1. Aplicar Seed (5 min)
Abra: https://app.supabase.com/project/chyhjtbgzwwdckhptnja/sql/new  
Cole: `supabase/seed/mock_data.sql` → Clique **Run**

### 2. Testar App (10 min)
```bash
cd rede
flutter pub get
flutter run -d chrome
```

### 3. Continuar Desenvolvimento
Abra `prompts.md` para próximas tarefas (14 passos total)

---

## 📦 Tecnologias

- **Frontend:** Flutter 3.x + Riverpod 2 + GoRouter
- **Backend:** Supabase (PostgreSQL + PostGIS)
- **Real-time:** Supabase Realtime + Edge Functions
- **Notificações:** Firebase Cloud Messaging
- **POS:** esc_pos_bluetooth (print receipt)
- **Mapas:** Google Maps Flutter
- **State:** Flutter Riverpod
- **Navigation:** GoRouter

---

## 📂 Estrutura do Projeto

```
REDE/
├── rede/                         # App Flutter
│   ├── lib/
│   │   ├── main.dart            # Entrypoint
│   │   ├── config/env.dart      # Supabase URLs
│   │   ├── services/            # Supabase client
│   │   ├── providers/           # Riverpod state
│   │   ├── screens/             # Telas do app
│   │   └── widgets/             # Componentes
│   └── pubspec.yaml             # Dependências
│
├── supabase/                     # Backend
│   ├── migrations/              # Schema SQL
│   ├── seed/                    # Dados exemplo
│   ├── functions/               # Edge Functions
│   └── config.toml              # Supabase config
│
└── [Documentação]
    ├── README.md
    ├── CHECKLIST_IMEDIATO.md
    ├── PROJECT_STATUS.md
    ├── GUIA_DEPLOY.md
    ├── prompts.md
    └── ...
```

---

## 🔐 Segurança

⚠️ **NUNCA COMMITAR:**
- `.env.local` — Credenciais sensíveis
- `SERVICE_ROLE_KEY` — Backend only
- Senhas do banco

✅ **ARQUIVOS IMPORTANTES:**
- `supabase/migrations/` — Schema controle de versão
- `supabase/seed/` — Dados de exemplo
- `supabase/functions/` — Edge Functions code
- `prompts.md` — Tarefas do projeto

---

## ⚙️ CI/CD com GitHub Actions

O projeto inclui workflow automático para deploy:
- **Arquivo:** `.github/workflows/supabase-seed-deploy.yml`
- **Acionado:** Push para `main` ou alterações em `supabase/seed/` ou `supabase/functions/`
- **O que faz:** Aplica migrations, seed, e deploy de Edge Functions

**Configuração necessária:** Veja [`.github/SECRETS_SETUP.md`](.github/SECRETS_SETUP.md)

---

## 🚀 Próximos Passos

1. **Hoje:** Aplique seed e rode `flutter run`
2. **GitHub:** Configure secrets em Settings (veja `.github/SECRETS_SETUP.md`)
3. **Passo 4:** Melhorar Auth Screens (conforme prompts.md)
4. **Passo 5+:** Implementar features (feed, search, orders, etc)
5. **Final:** Deploy (web + mobile)

Consulte `prompts.md` para a sequência completa (14 passos).

---

## 📞 Ajuda

- 📖 [Supabase Docs](https://supabase.com/docs)
- 🦋 [Flutter Docs](https://flutter.dev/docs)
- 🏗️ [Riverpod Docs](https://riverpod.dev)
- 🗺️ [Google Maps API](https://developers.google.com/maps)

---

**Status:** ✅ Fase 1-2 Completa | ⏳ Fase 3+ em Progresso  
**Data:** 14 de novembro de 2025  
**Próxima ação:** Leia [`CHECKLIST_IMEDIATO.md`](CHECKLIST_IMEDIATO.md)

## Cloud (production)

1. Use a mesma pasta `supabase/migrations` e aplique as migrations pelo Supabase CLI vinculando seu projeto remoto:

```powershell
supabase link --project-ref <PROJECT_REF>
supabase db push
```

2. Para a função de notificação `new_order_notification` use as Edge Functions do Supabase:

- Deploy: `supabase functions deploy new_order_notification --project-ref <PROJECT_REF>`
- Configure variáveis de ambiente da função: `SUPABASE_SERVICE_ROLE_KEY` e `FCM_SERVER_KEY` no painel de funções.

## Observações

- Eu adicionei uma trigger `notify_new_order` que usa `pg_notify('new_order', payload)` — isso permite integrar Realtime ou criar um evento de DB no painel do Supabase que chame sua Edge Function. Se você preferir que o trigger invoque diretamente a Edge Function via HTTP, crie um Database trigger no Dashboard que aponte para a função HTTP `https://<PROJECT>.functions.supabase.co/new_order_notification`.
- Arquivos criados: `supabase/migrations/001_full_schema.sql`, `supabase/seed/mock_data.sql`, `supabase/functions/new_order_notification/index.ts`, `.env` (exemplo), `supabase/.supabase/config.toml`.
