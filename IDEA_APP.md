# IDEA - Descrição detalhada do aplicativo "Rede"

## 1. Resumo executivo

"Rede" é um aplicativo multiplataforma (Flutter) que combina as funcionalidades de uma rede social com capacidades de marketplace para reservas, delivery/pedidos e venda de serviços. O objetivo principal é permitir que usuários descubram estabelecimentos (restaurantes, hotéis, serviços), compartilhem experiências, façam reservas ou pedidos, e gerenciem suas interações em um único lugar.

Público-alvo: usuários finais (consumidores) e estabelecimentos/fornecedores que desejam divulgar serviços, receber reservas e pedidos.

Valor proposto:
- Centralizar descoberta, reserva e consumo local (restaurantes, hospedagem, eventos, serviços).
- Misturar feed social para engajamento (posts, reviews) com transações (reservas/pedidos).
- Experiência mobile-first com design limpo (paleta roxo + branco) e integrações realtime via Supabase.


## 2. Objetivos e métricas de sucesso

Objetivos primários:
- Converter visitantes em usuários cadastrados.
- Facilitar reservas e pedidos com UX de 2-3 passos.
- Incentivar posts/reviews com ações sociais (likes, comments).

Métricas (KPIs):
- DAU/MAU (uso diário/mensal)
- Taxa de conversão (visita → cadastro)
- Número de reservas/pedidos por usuário
- Engajamento do feed: posts, curtidas, comentários
- Tempo médio para completar uma reserva/pedido


## 3. Arquitetura de alto nível

- Frontend: Flutter (Material 3), Riverpod para estado, GoRouter para navegação.
- Backend: Supabase (Postgres + Auth + Storage + Realtime).
- Deploy: multiplataforma (Android, iOS, Web, Desktop).

Componentes principais:
- UI Layer (presentation): telas, widgets, viewmodels
- Domain Layer: entidades e casos de uso
- Data Layer: repositórios e clientes Supabase
- Providers: Riverpod para injeção e estado


## 4. Funcionalidades principais (escopo inicial)

1. Autenticação
   - Login/Registro com email/senha
   - Recuperação de senha
   - Perfil de usuário com avatar (upload em bucket `avatars`)

2. Feed Social
   - Criar post (texto + imagens)
   - Curtir, comentar, compartilhar
   - Feed com paginação e ordenação

3. Busca & Descoberta
   - Buscar estabelecimentos por nome/categoria
   - Filtros: distância, rating, categoria
   - Página de detalhe do estabelecimento

4. Reservas
   - Criar/visualizar/cancelar reservas
   - Histórico de reservas do usuário

5. Pedidos
   - Criar pedidos de delivery ou retirada
   - Histórico e status do pedido

6. Perfil & Configurações
   - Editar dados, gerenciar métodos de pagamento e endereços
   - Notificações e preferências

7. Painel para Estabelecimentos (futuro)
   - Gerenciar itens, horários, reservas e pedidos


## 5. Telas (mapeamento para implementação atual)

Rotas principais definidas em `lib/providers/router_provider.dart`:
- `/login` → Tela de login (`lib/presentation/screens/auth/login_screen.dart`)
- `/register` → Tela de cadastro (`lib/presentation/screens/auth/register_screen.dart`)
- `/` → Home / Feed (`lib/presentation/screens/home/home_screen.dart`)
- `/feed` → Alias para feed
- `/search` → Busca (`lib/presentation/screens/search/search_screen.dart`)
- `/reservations` → Reservas (`lib/presentation/screens/reservations/reservations_screen.dart`)
- `/orders` → Pedidos (`lib/presentation/screens/orders/orders_screen.dart`)
- `/profile` → Perfil (`lib/presentation/screens/profile/profile_screen.dart`)

Cada tela inclui estados de loading, tratamento de erros e componentes reutilizáveis (cards, inputs, botões).


## 6. Fluxos de usuário chave (exemplos)

1) Fluxo de cadastro e primeiro acesso
- Usuário abre app -> `/login` -> seleciona `Cadastre-se` -> preenche nome/email/senha -> SUBMIT -> conta criada (Supabase Auth) -> redireciona para `/` (home)

Critérios de sucesso: conta criada e token armazenado; usuário consegue ver o feed.

2) Criar um post
- Usuário logado -> tocar FAB "Novo Post" -> inserir texto + imagens -> enviar -> post aparece no topo do feed

Critérios de sucesso: imagens salvas no bucket `posts`, entrada na tabela `posts` com FK do usuário.

3) Fazer reserva
- Usuário busca estabelecimento -> abre detalhes -> escolhe data/hora -> confirma reserva -> recebe confirmação

Critérios de sucesso: reserva gravada tabela `reservations` e visível em `/reservations`.

4) Fazer pedido
- Usuário escolhe estabelecimento -> seleciona itens no menu -> checkout -> paga (mock/provisionado) -> pedido criado

Critérios de sucesso: pedido criado em `orders`, status atualizável.


## 7. Modelo de dados (visão resumida)

O backend já possui um schema com ~18 tabelas. Resumo das tabelas-chave:
- users — cadastro de usuários (profile, avatar_url, role, metadata)
- establishments — estabelecimentos com localização, categoria, horário
- services / menu_items — itens oferecidos por estabelecimento
- posts — posts do feed (user_id, content, media_urls, created_at)
- comments — comentários vinculados a posts
- likes — relacionamento post/user para likes
- reservations — reservas feitas por usuários (establishment_id, user_id, date, status)
- orders — pedidos (user_id, establishment_id, status, total)
- order_items — itens dos pedidos
- reviews — avaliações associadas a establishments
- follows / followers — relacionamento social
- notifications — notificações do sistema

Relações importantes:
- `users` 1:N `posts`, `reservations`, `orders`, `reviews`
- `establishments` 1:N `menu_items`, `reservations`, `orders`, `reviews`

Observação: detalhes completos estão no arquivo SQL do schema no repositório.


## 8. Autenticação & Segurança

- Auth via Supabase (JWT)
- RLS (Row Level Security) ativo: políticas definem quem pode ler/escrever em cada tabela (ex.: só dono pode alterar seu pedido/reserva)
- Buckets: `posts`, `avatars`, `establishments` (configurados no Supabase)

Práticas recomendadas:
- Não expor a `service_role` em clientes; usar apenas no servidor para operações administrativas.
- Validar entradas no frontend e backend.
- Usar políticas RLS para limitar acesso a dados sensíveis.


## 9. Contratos de API (vista mínima)

Usando PostgREST / Supabase API padrão. Exemplos:

Autenticação:
- POST /auth/v1/token (supabase client)
- POST /auth/v1/signup

Posts:
- GET /rest/v1/posts?select=*&order=created_at.desc&limit=20&offset=0
- POST /rest/v1/posts (body: user_id, content, media_urls)

Estabelecimentos:
- GET /rest/v1/establishments?select=*&category=eq.Restaurant
- GET /rest/v1/establishments?id=eq.{id}

Reservas:
- POST /rest/v1/reservations
- GET /rest/v1/reservations?user_id=eq.{user_id}

Pedidos:
- POST /rest/v1/orders
- GET /rest/v1/orders?user_id=eq.{user_id}

Notas: a API real segue o formato do Supabase/PostgREST com filtros `eq`, `gte`, `lte`, etc. Aplicar RLS nas tabelas.


## 10. Design System (resumo)

Paleta principal:
- Roxo principal: `#7C3AED`
- Roxo claro: `#A855F7`
- Branco: `#FFFFFF`
- Background off-white: `#F8F7FF`

Tipografia: Material 3 com variações de display/headline/body.
Componentes: botões elevantedos com gradiente roxo, inputs com outline roxo no foco, cards com borda clara e sombra leve.


## 11. Requisitos não-funcionais

- Performance: carregamento do feed paginado (limit + offset ou cursor-based pagination)
- Disponibilidade: Supabase gerenciado — escalonamento conforme uso
- Segurança: RLS + validações; tokens expiram e são renovados
- Escalabilidade: separar leitura/escrita se necessário (cache)


## 12. Roadmap e próximos passos imediatos

Curto prazo (1-2 semanas):
- Corrigir `supabase_service.dart` (métodos `eq`, `range` e ajustes de tipos)
- Implementar autenticação real (login/register/logout)
- Ligar upload de avatar e imagens de post aos buckets
- Implementar leitura do feed com paginação

Médio prazo (2-6 semanas):
- Criar tela de Create Post
- Implementar likes e comentários persistentes
- Implementar detalhes de estabelecimento
- Implementar checkout básico para pedidos

Longo prazo (2-4 meses):
- Painel para estabelecimentos
- Integração pagamentos real
- Notificações push
- Real-time improvements (realtime feed, websockets)


## 13. Critérios de aceitação (exemplos de testes)

- Um usuário pode se registrar, logar e visualizar o feed.
- Um usuário logado consegue criar um post com imagem e vê-lo no topo do feed.
- Um usuário consegue criar uma reserva e vê-la em `/reservations`.
- Operações CRUD respeitam as políticas RLS (usuário não vê reservas de outros usuários).


## 14. Como usar este documento

- Referência para desenvolvedores que irão continuar o frontend/backend.
- Base para escrever testes de aceitação e planos de QA.
- Documento vivo: atualize conforme mudanças no schema ou prioridades.


## 15. Referências úteis no repositório
- Schema SQL: `SUPABASE_SCHEMA.sql` (contém definição das 18 tabelas)
- Configuração Supabase usada em desenvolvimento: `dados_superbase.txt` (não comitar em repositórios públicos em produção)
- Páginas de referência: `lib/presentation/screens/` (implementação das telas)
- Routes: `lib/providers/router_provider.dart`


---

Se quiser, eu já adiciono um diagrama ERD simplificado (texto) com as 10 tabelas principais, e também gero uma especificação OpenAPI mínima para os endpoints listados. Quer que eu gere isso agora?  

*Arquivo criado: `IDEA_APP.md`*