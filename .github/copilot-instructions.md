# 🤖 Instruções para Agentes de IA - Projeto REDE

Este documento guia agentes de IA para contribuições produtivas ao projeto REDE, uma aplicação Flutter super-app com Supabase.

## 🎯 Visão Geral da Arquitetura

**REDE** é um super-app Flutter multiplataforma (Web, iOS, Android) que funciona como marketplace para estabelecimentos (restaurantes, bares, hotéis, fornecedores de eventos).

### Componentes Principais

- **Frontend:** Flutter 3.x com Riverpod (state management) + GoRouter (navegação)
- **Backend:** Supabase (PostgreSQL + PostGIS + Edge Functions + Realtime)
- **Notificações:** Firebase Cloud Messaging (FCM) + Supabase Edge Functions
- **Dados:** 10 tabelas PostgreSQL (profiles, establishments, orders, events, etc)

### Fluxo de Dados

1. **Inicialização:** `main.dart` → `SupabaseClientService.init()` + Firebase setup
2. **Auth:** Riverpod `authProvider` → `AuthNotifier` → `SupabaseClientService` → Supabase Auth
3. **Dados:** Providers consultam `SupabaseClientService.client.from('table_name')`
4. **Notificações:** FCM token armazenado em `profiles.fcm_token` → Edge Function `new_order_notification`

## 📂 Estrutura de Diretórios e Padrões

```
lib/
├── config/env.dart          # Variáveis de ambiente (SUPABASE_URL, ANON_KEY)
├── services/
│   ├── supabase_client.dart # Cliente singleton + helpers (auth, storage, realtime)
│   └── geo_service.dart     # Geolocalização
├── models/                   # Modelos com fromJson/toJson (user, establishment, order, etc)
├── providers/
│   ├── auth/auth_provider.dart        # StateNotifier<AsyncValue<AuthState>>
│   ├── cart/                          # Cart state
│   ├── location/                      # Localização do usuário
│   └── role/                          # Role do usuário (consumer/partner)
└── screens/                  # Telas estruturadas por feature
    ├── auth/                 # Login, Register
    ├── feed/                 # Feed de posts
    ├── search/               # Busca
    ├── discover/             # Descobrir estabelecimentos
    ├── orders/               # Pedidos do usuário
    └── settings/             # Configurações
```

## 🔑 Padrões de Código

### 1. **State Management com Riverpod**
Usar `StateNotifierProvider` para estado mutável:
```dart
class MyNotifier extends StateNotifier<AsyncValue<T>> { ... }
final myProvider = StateNotifierProvider<MyNotifier, AsyncValue<T>>(
  (ref) => MyNotifier(),
);
```
- Sempre envolver estado complexo em `AsyncValue<T>` (permite `.loading`, `.error`, `.data`)
- Notifiers recebem `Ref ref` para acessar outros providers

### 2. **Modelos com Serialização JSON**
Padrão para todos os modelos (`user.dart`, `establishment.dart`, etc):
```dart
class UserModel {
  factory UserModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```
- snake_case no JSON (Ex: `created_at` → `createdAt`)
- Sempre tratar valores nulos com `as T?`

### 3. **Autenticação e Autorização**
- `SupabaseClientService.getCurrentUser()` retorna `User?` (verificar null)
- Role armazenado em `user.userMetadata['role']` (consumer/partner)
- `authProvider` fornece `AuthState` com `userId` e `role`
- Proteção de rotas em `main.dart` via `GoRouter.redirect`

### 4. **Consultas ao Banco de Dados**
```dart
// Ler
final data = await SupabaseClientService.client
    .from('establishments')
    .select()
    .eq('owner_id', userId);

// Upsert (criar ou atualizar)
await SupabaseClientService.client
    .from('profiles')
    .upsert({'id': user.id, 'role': role});
```
- Sempre tratar exceções (rede, auth, permissões)
- Usar `stream()` para dados em tempo real (realtime subscriptions)

### 5. **Armazenamento de Imagens**
```dart
final publicUrl = await SupabaseClientService.uploadImage(
  path: 'posts/$userId/${uuid}.jpg',
  bytes: imageBytes,
);
```

## 🚀 Workflows de Desenvolvimento

### Setup Inicial (15 min)
```powershell
# 1. Clonar e entrar no projeto
cd REDE-APP

# 2. Instalar dependências
flutter pub get

# 3. Configurar variáveis de ambiente (substitua por valores reais)
$env:SUPABASE_URL="https://chyhjtbgzwwdckhptnja.supabase.co"
$env:SUPABASE_ANON_KEY="<sua-chave-anonima>"

# 4. Aplicar seed no Supabase (via SQL Editor do Dashboard)
# Copie conteúdo de: supabase/seed/mock_data.sql
# Cole em: https://app.supabase.com/project/.../sql/new

# 5. Rodar app
flutter run -d chrome
```

### Build para Produção
```powershell
# Web
flutter build web --release

# APK (Android)
flutter build apk --release

# Deploy de Edge Functions
supabase link --project-ref <PROJECT_REF>
supabase functions deploy new_order_notification
```

### Testes
```powershell
flutter test
```

## 🔗 Integração com Supabase

### Edge Functions
- Localização: `supabase/functions/new_order_notification/index.ts`
- Acionada por trigger `notify_new_order` ao inserir ordem
- Acessa `SUPABASE_SERVICE_ROLE_KEY` (variável de ambiente na função)
- Envia notificação FCM via `FCM_SERVER_KEY`

### Real-time (Subscriptions)
```dart
SupabaseClientService.subscribeOrders(
  establishmentId,
  (event) {
    // event = lista de ordens atualizado
    setState(() { orders = event; });
  },
);
```

### PostGIS para Geolocalização
- Tabela `establishments` tem coluna `location_point geometry(point, 4326)`
- Usar em queries: `order_by('location_point <-> point(\$lon, \$lat)')`

## ⚠️ Convenções de Segurança

- **Nunca commitar:** `.env.local`, `SERVICE_ROLE_KEY` hardcoded
- **Variáveis sensíveis:** Via `--dart-define` ou GitHub Secrets (CI/CD)
- **Row-Level Security (RLS):** Habilitado em `supabase/migrations/` — sempre verificar políticas antes de inserir dados

## 📋 Tarefas Comuns

### Adicionar Nova Tela
1. Criar arquivo `lib/screens/novo_feature/novo_feature_screen.dart`
2. Adicionar rota em `main.dart` → `GoRouter`
3. Se precisar estado, criar provider em `lib/providers/novo_feature/`

### Adicionar Campo ao Banco
1. Criar migration em `supabase/migrations/202511<data>_<descricao>.sql`
2. Atualizar modelo correspondente (`lib/models/`)
3. Executar: `supabase db push` (local) ou via Dashboard (remoto)

### Integrar Nova API
1. Criar service em `lib/services/`
2. Expor métodos via provider (`Riverpod`)
3. Consumir em widgets/providers via `ref.watch()`

## 🔍 Debugging

- **Erros Supabase:** Verificar Console do Dashboard (`Logs`)
- **Firebase/FCM:** Acessar `firebase_messaging` logs no console
- **Estado Riverpod:** Instalar devtools (`flutter pub add dev:riverpod_generator`)
- **Banco local:** `supabase db reset` para recriar schema + seed

## 📚 Referências Rápidas

| Tecnologia | Docs | Uso no Projeto |
|---|---|---|
| Flutter | https://flutter.dev/docs | UI e navegação |
| Riverpod | https://riverpod.dev | State management |
| Supabase | https://supabase.com/docs | Backend (auth, DB, storage) |
| GoRouter | https://pub.dev/packages/go_router | Roteamento |
| Firebase Messaging | https://firebase.flutter.dev | Notificações push |
| Google Maps | https://pub.dev/packages/google_maps_flutter | Mapas (se usado) |

---

**Data:** 14 de novembro de 2025  
**Versão:** 1.0  
**Mantido por:** Equipe REDE
