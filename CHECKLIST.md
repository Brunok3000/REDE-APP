# 📋 CHECKLIST DE TAREFAS - REDE App

## ✅ Fase 1 - Boilerplate & Core (Completo)
- [x] **Tarefa 1:** Boilerplate Flutter com Riverpod + GoRouter
  - ✅ `lib/main.dart` com MaterialApp.router
  - ✅ `pubspec.yaml` com todas as dependências
  - ✅ Estrutura de pastas

- [x] **Tarefa 2:** Integração Supabase
  - ✅ `lib/services/supabase_client.dart` com client singleton
  - ✅ `lib/providers/auth/auth_provider.dart` com AsyncValue

- [x] **Tarefa 3:** Schema SQL + RLS
  - ✅ 10 tabelas criadas no Supabase
  - ✅ RLS policies implementadas
  - ✅ Mock data inserido

## ✅ Fase 2 - UI Core & Auth (Completo)
- [x] **Tarefa 4:** Auth Screens
  - ✅ LoginScreen com email/senha
  - ✅ RegisterScreen com role selector (consumer/partner)
  - ✅ Tratamento de erros com FlutterToast

- [x] **Tarefa 5:** BottomNav com Role-Based
  - ✅ Navegação condicional (consumer vs partner)
  - ✅ 5 abas para consumidor (Home, Search, Discover, Orders, Settings)
  - ✅ 4 abas para parceiro (Dashboard, Pedidos, Relatórios, Config)

## ✅ Fase 3 - Screens Principais (Completo)
- [x] **Tarefa 6:** FeedScreen
  - ✅ ListView infinito com posts
  - ✅ Realtime subscription via Supabase
  - ✅ PostCreateModal com upload de imagem
  - ✅ Indicação entre usuários

- [x] **Tarefa 7:** SearchScreen
  - ✅ Busca textual
  - ✅ Filtros por tipo e geolocalização
  - ✅ B2B toggle para partners
  - ✅ EstablishmentCard com distância

- [x] **Tarefa 8:** DiscoverScreen
  - ✅ Carousel de eventos populares
  - ✅ Lista de eventos próximos (com geofiltro)
  - ✅ Realtime updates

- [x] **Tarefa 9:** OrdersScreen
  - ✅ View consumidor: histórico de pedidos
  - ✅ View parceiro: gerenciamento com abas (Pendentes, Preparando, Prontos)
  - ✅ Botões de aceitar/rejeitar para parceiros

## 🟡 Fase 4 - Delivery & Serviços (Em Progresso)
- [ ] **Tarefa 10:** Delivery + Menu
  - 🟡 EstablishmentProfileScreen criado
  - 🟡 Menu listing com preços
  - 🟡 Cart com Riverpod provider
  - 🟡 Checkout modal com confirmação
  - ⏳ **TODO:** Conectar SearchScreen/DiscoverScreen à tela
  - ⏳ **TODO:** Testar flow completo

- [ ] **Tarefa 11:** Reserva + Ingressos + Hospedagem
  - ⏳ Tabs em EstablishmentProfile
  - ⏳ TableCalendar para datas
  - ⏳ Disponibilidade realtime
  - ⏳ Insert em `table_reservations`, `ticket_purchases`, `room_bookings`

## ⏳ Fase 5 - POS & Avançado (Pendente)
- [ ] **Tarefa 12:** POS PWA
  - ⏳ Dashboard com pedidos cards
  - ⏳ Detalhes com aceitar/recusar/marcar como pronto
  - ⏳ KDS (Kitchen Display System)
  - ⏳ Histórico
  - ⏳ Realtime channels por estabelecimento
  - ⏳ Offline com Hive

- [ ] **Tarefa 13:** Push Notifications
  - ⏳ Firebase setup (em main.dart)
  - ⏳ FCM token storage em profiles.fcm_token
  - ⏳ Edge Function para envio
  - ⏳ Vibrate + Sound no POS

- [ ] **Tarefa 14:** Monetização
  - ⏳ Tabela `subscriptions`
  - ⏳ UI de comparação de pacotes
  - ⏳ Mock Stripe integration

---

## 📊 Status Geral
- **Completo:** 9/14 tarefas (64%)
- **Em Progresso:** 1/14 tarefa (7%)
- **Pendente:** 4/14 tarefas (29%)

## 🚀 Próximas Ações
1. **Conectar EstablishmentProfileScreen** aos resultados de Search/Discover
2. **Testar Delivery + Menu + Cart flow** completo
3. **Implementar Tarefa 11:** Reservas + Ingressos + Hospedagem
4. **Deploy via CI/CD** quando Tarefa 14 estiver pronta

---

**Última Atualização:** 14 de novembro de 2025
**Versão do App:** 1.0.0+1
**Flutter SDK:** 3.9.2+
**Supabase:** 2.10.3
