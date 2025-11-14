# Prompts para geração do projeto REDE

Abaixo estão os 14 prompts enviados para gerar funcionalidades, cada um com o que deve gerar e o teste pós-implementação.

| # | Prompt | O que Gera | Teste Após |
|---:|---|---|---|
| 1 | """Crie um boilerplate Flutter completo para um superapp chamado 'rede'. Use Riverpod 2 para state management, GoRouter para navigation. Estrutura pastas: lib/main.dart, lib/config/env.dart, lib/providers (auth, role, cart, location), lib/models (user, establishment, order, reservation, ticket, booking), lib/screens (auth, feed, search, discover, orders, settings), lib/widgets (bottom_nav, establishment_card, cart_modal, profile_public), lib/services (supabase_client, geo_service). Adicione dependências no pubspec.yaml: supabase_flutter, riverpod, go_router, google_maps_flutter, firebase_messaging, intl, uuid, esc_pos_bluetooth. Configure .env com VITE_SUPABASE_URL e ANON_KEY. Main.dart com MaterialApp.router e theme Tailwind-like (blue primary).""" | Projeto base + pubspec + main.dart + pastas vazias. | flutter pub get → flutter run -d chrome (ver tela vazia). |
| 2 | """Implemente integração Supabase completa em lib/services/supabase_client.dart. Crie client com auth persist, realtime enabled. Adicione funções para login (email/Google), registro com role (consumer/partner), get current user. Em lib/providers/auth_provider.dart, use Riverpod para state de user e role. Adicione loading/error states com AsyncValue.""" | Supabase setup + auth. | Teste login mock no console. |
| 3 | """Crie schema SQL completo para Supabase em um arquivo supabase_schema.sql. Tabelas: profiles (id, role, name, avatar, phone), establishments (id, owner_id, name, type, address_json, location_point, services_json), menu_items, orders, table_reservations, events, ticket_purchases, room_bookings, indications (user_id, target_id, message), posts (id, author_id, content, images). Adicione RLS policies para cada tabela: public read para establishments, own edit para profiles/establishments, role-based para orders (partner only see own). Habilite PostGIS.""" | SQL para DB. | Cole no Supabase Dashboard SQL Editor → run. Seed manual. |
| 4 | """Implemente screens/auth: LoginScreen com form email/senha + Google button, RegisterScreen com role selector. Use Riverpod para auth state. Redirecione para FeedScreen após login. Adicione toasts com FlutterToast para errors.""" | Telas auth. | flutter run → teste login. |
| 5 | """Implemente BottomNav em lib/widgets/bottom_nav.dart com conditional por role (Home, Search, Discover, Orders, Settings). Em Orders: consumidor vê histórico, partner vê gerenciamento + relatórios. Use GoRouter para routes.""" | Navegação. | Teste nav. |
| 6 | """Implemente FeedScreen: Infinite list posts com ListView.builder, realtime subscription para updates. PostCreateModal com image upload para Storage. Indicar button em perfis com insert em indications.""" | Feed + social. | Poste algo → veja realtime. |
| 7 | """Implemente SearchScreen: Input com filtros (tipo, geo, B2B toggle para partners). Resultados em ListView com EstablishmentCard. Use PostGIS query para geo (ST_DWithin). Fallback IP geo.""" | Pesquisa. | Busque mock data. |
| 8 | """Implemente DiscoverScreen: Carousel eventos bombando (baseado em engajamento), lista vertical com geo filter. Use GoogleMapsFlutter para mapa opcional.""" | Descubra. | Veja lista. |
| 9 | """Implemente serviços: Delivery em EstablishmentProfileScreen com menu list → add to cart (Riverpod provider) → checkout modal com mock Stripe. Envie insert para orders, trigger realtime para POS.""" | Delivery. | Faça pedido → veja em DB. |
| 10 | """Implemente Reserva Mesa, Ingressos, Hospedagem em tabs do EstablishmentProfile. Calendário com TableCalendar, disponibilidade realtime. Insert em tabelas respectivas.""" | Outros serviços. | Teste reservas. |
| 11 | """Implemente rede POS como PWA em mesma codebase (web target). Screens: Dashboard (pedidos cards), Detail (aceitar/recusar), KDS (itens fila), History. Realtime channels por establishment. Adicione esc_pos_bluetooth para print. Offline com local storage (Hive).""" | POS completo. | Abra web em tablet mode → teste pedido chegando. |
| 12 | """Adicione Push Notifications com firebase_messaging. Configure FCM no Supabase Functions para new order trigger. Vibrate + sound no POS.""" | Notificações. | Teste push. |
| 13 | """Implemente pacotes monetização: Tabela subscriptions. UI em Settings para parceiro: comparação pacotes, upgrade button com mock Stripe Billing.""" | Monetização. | Teste upgrade. |
| 14 | """Gere README.md completo: Setup (flutter install, env, Supabase create), Run (web/mobile), Deploy (Vercel web, APK build), Troubleshooting (common errors).""" | Docs. | Leia README. |


---

Observações:
- Criei este arquivo na raiz do repositório `prompts.md` e irei commitar para garantir que fique persistente no controle de versão.
- Se quiser, posso também criar uma cópia em `.github/` como backup para reduzir chance de exclusão acidental.
