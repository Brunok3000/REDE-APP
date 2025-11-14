# 🔧 Guia de Aplicação de Migrations - Supabase

## Status das Migrations

Todas as migrations foram revisadas e validadas ✅

| Migration | Status | Descrição | Ordem |
|-----------|--------|-----------|-------|
| `20251115000002_complete_schema.sql` | ✅ Validado | 10 tabelas + RLS policies + índices + PostGIS | 1º |
| `20251115000003_create_order_notifications_outbox.sql` | ✅ Validado | Outbox pattern + trigger para notificações | 2º |

---

## Como Aplicar as Migrations

### Opção 1: Via Dashboard Supabase (Recomendado para Primeira Vez)

1. **Abra o SQL Editor do Supabase:**
   - Link: https://app.supabase.com/project/chyhjtbgzwwdckhptnja/sql/new

2. **Para a Migration 1 (Schema Completo):**
   - Abra o arquivo: `supabase/migrations/20251115000002_complete_schema.sql`
   - Cole TODO o conteúdo no editor SQL do Supabase
   - Clique **Run** (ou `Ctrl+Enter`)
   - Aguarde a confirmação: "Query returned no rows" (é esperado para CREATE TABLE)

3. **Para a Migration 2 (Outbox + Trigger):**
   - Abra: `supabase/migrations/20251115000003_create_order_notifications_outbox.sql`
   - Cole todo o conteúdo
   - Clique **Run**
   - Confirmação esperada: sucesso

**⚠️ IMPORTANTE:** A ordem está corrigida. A Migration 2 **DEVE** rodar APÓS a Migration 1 (orders table deve existir).

---

### Opção 2: Via Supabase CLI (Para Desenvolvimento Local)

Se você tem o Supabase CLI instalado:

```bash
# 1. Vincular projeto local ao Supabase remoto
supabase link --project-ref chyhjtbgzwwdckhptnja

# 2. Aplicar todas as migrations
supabase db push

# 3. Verificar status
supabase db list --schema public
```

---

### Opção 3: Via GitHub Actions (Auto-Deploy - Em Produção)

O repositório tem um workflow GitHub Actions configurado para deploying Edge Functions automaticamente. 

**Trigger:** Quando você faz push para `master` com mudanças em `supabase/functions/`.

Para rodar manualmente:
- Vá para: GitHub → Actions → "Deploy Supabase Function"
- Clique "Run workflow" → Branch: `master`

---

## ✅ Validação Pós-Migrations

Após aplicar as migrations, valide:

### 1. Tabelas Criadas

No SQL Editor do Supabase, execute:

```sql
SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;
```

Resultado esperado (10 tabelas):
- `establishments`
- `events`
- `indications`
- `menu_items`
- `order_notifications` ← Novo (outbox)
- `orders`
- `posts`
- `profiles`
- `room_bookings`
- `table_reservations`
- `ticket_purchases`

### 2. RLS Policies Ativas

```sql
SELECT tablename, policyname FROM pg_policies WHERE schemaname = 'public' ORDER BY tablename;
```

Cada tabela deve ter pelo menos 1 policy. Exemplos:
- `profiles`: 3 policies (read own, insert self, update own)
- `orders`: 4 policies (consumer read/write, partner read/update)
- `posts`: 3 policies (public read, author write, author update)

### 3. Outbox Trigger Configurado

```sql
SELECT trigger_name, event_object_table 
FROM information_schema.triggers 
WHERE trigger_schema = 'public' 
AND event_object_table = 'orders';
```

Resultado esperado:
- Trigger: `trg_orders_enqueue_notification`

### 4. Índices de Performance

```sql
SELECT indexname FROM pg_indexes WHERE schemaname = 'public' ORDER BY indexname;
```

Deve incluir (mínimo):
- `idx_establishments_location`
- `idx_establishments_owner`
- `idx_orders_consumer`
- `idx_orders_establishment`
- `idx_posts_created_at`
- `idx_order_notifications_sent_created_at` ← Novo (outbox)

### 5. PostGIS Habilitado

```sql
SELECT extname FROM pg_extension WHERE extname = 'postgis';
```

Resultado: deve listar `postgis`

---

## 🔐 RLS Políticas (Resumo)

| Tabela | Acesso |
|--------|--------|
| **profiles** | Cada usuário lê/atualiza apenas seu próprio perfil |
| **establishments** | Públicos para leitura; proprietário pode criar/editar/deletar |
| **menu_items** | Públicos para leitura; proprietário (via establishment) pode CRUD |
| **orders** | Consumidor vê seus pedidos; parceiro vê pedidos de seu estabelecimento |
| **table_reservations** | Consumidor vê suas reservas; parceiro vê todas as reservas do estabelecimento |
| **events** | Públicos para leitura; parceiro pode criar/editar |
| **ticket_purchases** | Consumidor vê seus tickets; parceiro vê tickets dos events |
| **room_bookings** | Consumidor vê suas reservas; parceiro vê todas do estabelecimento |
| **posts** | Públicos para leitura; autor pode criar/editar/deletar |
| **indications** | Consumidor vê suas indicações |
| **order_notifications** | Gerenciada internamente (não precisa RLS; triggers + Edge Function) |

---

## 📊 PostGIS (Geolocalização)

A coluna `location_point` em `establishments` usa geometria PostGIS para buscas geoespaciais.

### Exemplo de Query: Estabelecimentos Próximos

```sql
SELECT *
FROM public.nearby_establishments(
  lat := -23.5505,  -- São Paulo (latitude)
  lng := -46.6333,  -- São Paulo (longitude)
  radius_meters := 5000  -- 5 km
);
```

Retorna: todos os estabelecimentos dentro de 5 km, com `distance_meters` calculada.

---

## 🚨 Troubleshooting

### Erro: "relation 'public.orders' does not exist"

**Causa:** Tentou rodar migration 2 (outbox) sem ter rodado migration 1 primeiro.

**Solução:** 
1. Execute migration 1 (schema completo) ANTES de migration 2
2. Valide que `orders` tabela existe com query acima

### Erro: "role 'postgres' does not have permission"

**Causa:** RLS está bloqueando sua conta/role.

**Solução:**
1. Use `SECURITY DEFINER` em functions (já configurado)
2. Ou desabilite RLS temporariamente (⚠️ apenas para testes)

```sql
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
-- ... teste ...
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
```

### Erro: "PostGIS not available"

**Causa:** Extension não foi criada.

**Solução:** Execute manualmente:
```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

---

## 📝 Nota sobre os Seeders

Após aplicar as migrations, opcionalmente seed com dados de teste:

```sql
-- Abra: supabase/seed/mock_data.sql
-- Cole no SQL Editor do Supabase
-- Clique Run
```

Isso populará:
- 3 usuários de teste (consumer + partner)
- 5 estabelecimentos
- 10 menu items
- 5 posts
- 3 eventos

---

## ✨ Pronto!

Suas migrations estão prontas para produção. Agora você pode:

1. **Rodar o app:** `flutter run -d chrome`
2. **Testar login:** Use as credenciais de seed (check `mock_data.sql`)
3. **Monitorar logs:** Vá para Supabase → Logs → SQL Editor

Sucesso! 🚀
