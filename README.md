# 🌐 Rede Social App - Documentação Completa# Rede - MVP Social + Booking + Delivery + Eventos



## 📋 Visão Geral**Rede** é um aplicativo Flutter multiplataforma que combina funcionalidades de rede social com um marketplace completo para reservas, delivery, agendamento de serviços e venda de ingressos.



Aplicativo Flutter profissional com arquitetura limpa (MVVM + Riverpod), integração Supabase, autenticação, rede social e marketplace.## 📋 Visão Geral



**Status**: ✅ Backend 100% | 🔨 Frontend em desenvolvimento### Características Principais



---#### 1. **Rede Social**

- Posts com imagens

## 🎯 Funcionalidades Principais- Feed em tempo real (Realtime do Supabase)

- Likes e comentários

### ✅ Implementado- Follow/unfollow de usuários

- ✅ Backend services (50+ métodos)- Perfis de usuários com avatar e bio

- ✅ Database schema (18 tabelas)

- ✅ Storage buckets (3 buckets)#### 2. **Busca e Catálogo de Estabelecimentos**

- ✅ Autenticação Supabase- Busca full-text por nome/descrição/categoria

- ✅ Row Level Security (RLS)- Filtros por tipo (hotéis, bares, restaurantes, salões, etc)

- Busca geolocalizada (estabelecimentos próximos)

### 🔨 Frontend (Em Progresso)- Rating e avaliações

- 🔨 **Tela de Login** - Autenticação com email/senha- Categorias: hotéis, bares, restaurantes, baladas, lanchonetes, mecânica, salão de beleza, padaria, eventos

- 🔨 **Tela de Registro** - Criar nova conta

- 🔨 **Home Feed** - Feed social com posts#### 3. **Reservas (Bookings)**

- 🔨 **Busca Estabelecimentos** - Localizar negócios- Reserva de quartos em hotéis (com verificação de disponibilidade)

- 🔨 **Perfil** - Gerenciar dados do usuário- Reserva de mesas em bares/restaurantes (se oferecido)

- 🔨 **Minhas Reservas** - Histórico de reservas- Agendamento de serviços (salões, mecânica, etc)

- 🔨 **Meus Pedidos** - Histórico de pedidos- Sistema de confirmação e cancelamento

- Histórico de reservas

---

#### 4. **Delivery**

## 🛠️ Tech Stack- Catálogo de itens/menu dos estabelecimentos

- Carrinho de compras

```- Checkout com cálculo de taxas/delivery

Frontend: Flutter 3.24.0- Rastreamento de pedidos em tempo real

State Management: Riverpod + Notifier- Histórico de pedidos

Navigation: Go Router

Backend: Supabase (PostgreSQL)#### 5. **Eventos e Ingressos**

Authentication: Supabase Auth- Listagem de eventos

Storage: Supabase Storage- Compra de ingressos com geração de QR code

API: Supabase REST API- Detalhes do evento (data, local, preço)



Design System:### Tipos de Usuários

- Paleta: Roxo (#7C3AED) + Branco (#FFFFFF)

- ResponsiveLayout: Flutter ScreenUtil1. **Usuário Comum (`user`)**

- Componentes: Material 3   - Pode fazer posts

```   - Pode buscar e fazer reservas

   - Pode fazer pedidos de delivery

---   - Pode comprar ingressos

   - Pode avaliar estabelecimentos

## 📁 Estrutura de Pastas

2. **Parceiro (`partner`)**

```   - Pode gerenciar seu estabelecimento

lib/   - Pode oferecer serviços (delivery, reservas, agendamentos, eventos)

├── main.dart                          # Entry point   - Pode gerenciar menu/itens

├── core/   - Pode gerenciar disponibilidade

│   ├── theme/   - Pode visualizar reservas e pedidos

│   │   ├── app_colors.dart           # Cores (roxo/branco)

│   │   ├── app_typography.dart       # Tipografia---

│   │   └── app_theme.dart            # Material 3 Theme

│   ├── constants/## 🏗️ Arquitetura

│   │   └── app_constants.dart        # Constantes

│   └── services/### Estrutura de Pastas

│       └── supabase_service.dart     # Backend service

├── data/```

│   ├── models/                        # DTOs/Modelslib/

│   └── repositories/                  # Camada de dados├── core/

├── domain/│   ├── theme/              # Tema global da app

│   ├── entities/                      # Entidades de negócio│   ├── utils/              # Utilitários (extensions, helpers)

│   └── usecases/                      # Casos de uso│   └── services/           # Serviços (Supabase, Storage, etc)

├── presentation/├── data/

│   ├── screens/                       # Telas principais│   ├── datasources/        # Camada de acesso ao banco/API

│   │   ├── auth/│   ├── models/             # Modelos de dados (JSON serialization)

│   │   │   ├── login_screen.dart│   └── repositories/       # Repositórios (implementação de contratos)

│   │   │   ├── register_screen.dart├── domain/

│   │   │   └── forgot_password_screen.dart│   ├── entities/           # Entidades de negócio (puras)

│   │   ├── home/│   ├── repositories/       # Contratos de repositórios (abstratos)

│   │   │   ├── home_screen.dart│   └── usecases/           # Casos de uso (lógica de negócio)

│   │   │   ├── feed_screen.dart├── presentation/

│   │   │   └── search_screen.dart│   ├── screens/            # Telas/páginas

│   │   ├── profile/│   ├── widgets/            # Componentes reutilizáveis

│   │   │   ├── profile_screen.dart│   └── viewmodels/         # ViewModels (estado + lógica de apresentação)

│   │   │   └── edit_profile_screen.dart├── providers/              # Riverpod providers

│   │   ├── reservations/└── main.dart               # Entrada do app

│   │   │   └── reservations_screen.dart```

│   │   └── orders/

│   │       └── orders_screen.dart### Padrões Utilizados

│   ├── viewmodels/                    # MVVM ViewModels

│   │   ├── auth_viewmodel.dart- **Clean Architecture**: Separação em camadas (Domain, Data, Presentation)

│   │   ├── home_viewmodel.dart- **Repository Pattern**: Abstração de acesso a dados

│   │   └── profile_viewmodel.dart- **Riverpod**: Gerenciamento de estado e injeção de dependências

│   └── widgets/                       # Componentes reutilizáveis- **Go Router**: Navegação com suporte a deep linking

│       ├── common/- **MVC/MVVM**: ViewModel para lógica de apresentação

│       ├── auth/

│       └── home/---

├── providers/                         # Riverpod providers

│   ├── auth_provider.dart## 🗄️ Banco de Dados (Supabase/PostgreSQL)

│   ├── router_provider.dart

│   └── theme_provider.dart### Tabelas Principais

└── assets/

    ├── images/| Tabela | Descrição |

    ├── icons/|--------|-----------|

    └── lottie/| `users` | Usuários do sistema (comuns e parceiros) |

```| `establishments` | Restaurantes, hotéis, salões, etc |

| `rooms` | Quartos de hotéis |

---| `room_availability` | Disponibilidade de quartos por data |

| `services` | Serviços oferecidos (corte, mecânica, etc) |

## 🎨 Design System - Cores| `menu_items` | Itens de menu para delivery |

| `orders` | Pedidos de delivery |

```dart| `order_items` | Itens dentro de um pedido |

// Paleta Principal| `reservations` | Reservas de quartos, mesas, serviços |

Primary: #7C3AED (Roxo)| `posts` | Posts da rede social |

Secondary: #A855F7 (Roxo Claro)| `comments` | Comentários em posts |

Surface: #FFFFFF (Branco)| `likes` | Likes em posts e comentários |

Background: #F8F7FF (Roxo bem claro)| `events` | Eventos e shows |

Error: #EF4444 (Vermelho)| `tickets` | Ingressos vendidos |

Success: #10B981 (Verde)| `reviews` | Avaliações de estabelecimentos |

Warning: #F59E0B (Laranja)| `follows` | Relacionamentos de follow entre usuários |

| `notifications` | Notificações para usuários |

// Variações| `payments` | Histórico de pagamentos |

Roxo Escuro: #6D28D9

Roxo Médio: #7C3AED### Segurança (RLS - Row Level Security)

Roxo Claro: #A855F7

Roxo Muito Claro: #F3E8FF- Usuários só veem seus próprios dados privados

Branco: #FFFFFF- Dados públicos (posts, estabelecimentos) visíveis para todos

Cinza: #6B7280- Parceiros veem reservas/pedidos de seus estabelecimentos

Cinza Claro: #E5E7EB- Notificações apenas do usuário dono

```

---

---

## 🛠️ Dependências Principais

## 🔐 Autenticação & Segurança

```yaml

### Fluxo de Autenticação# Supabase & Backend

1. **Login** - Email + Senhasupabase_flutter: ^2.9.1

2. **Registro** - Criar conta

3. **Recuperação** - Esqueceu senha# State Management

4. **Session** - Mantém token JWTflutter_riverpod: ^2.6.1

5. **Logout** - Clear sessionriverpod: ^2.5.1



### Row Level Security (RLS)# Routing

- ✅ Usuários veem apenas dados públicos + seus dadosgo_router: ^15.1.3

- ✅ Posts públicos visíveis para todos

- ✅ Estabelecimentos ativos listáveis# UI

- ✅ Pedidos/Reservas apenas do próprio usuárioflutter_screenutil: ^5.9.3

flutter_svg: ^2.1.0

---google_fonts: ^6.2.1

lottie: ^3.3.1

## 📱 Telas & Fluxos

# Media & Storage

### 1️⃣ Autenticaçãoimage_picker: ^1.1.2

**Login Screen**cached_network_image: ^3.3.1

- Email/Senha

- Botão "Esqueceu a Senha?"# Maps & Location

- Link "Criar Conta"google_maps_flutter: ^2.12.3

- Loading stategeolocator: ^14.0.2

- Validação de formuláriogeocoding: ^4.0.0



**Register Screen**# API & Network

- Nome completodio: ^5.4.0

- Emailretrofit: ^4.0.1

- Senha

- Confirmação de senha# Utilities

- Terms & Conditionsuuid: ^4.0.0

- Validaçãointl: ^0.19.0

- Link "Já tem conta? Faça login"```



**Forgot Password Screen**---

- Email input

- Botão "Enviar"## 🚀 Setup & Instalação

- Confirmação de email

- Link de reset### Pré-requisitos



### 2️⃣ Home Feed- Flutter SDK ^3.7.2

**Home Screen**- Dart ^3.7.2

- AppBar com logo + menu- Conta Supabase (https://supabase.com)

- Feed de posts

- Botão FAB "Novo Post"### 1. Clone o Repositório

- Bottom navigation bar

```bash

**Feed Screen**cd "base app"

- Lista de posts com:flutter create rede

  - Avatar do autorcd rede

  - Nome e data```

  - Conteúdo

  - Imagens### 2. Configure Supabase

  - Contador de likes/comentários

  - Botões de ação1. Crie um projeto em https://supabase.com

2. Copie a URL e chave anônima do projeto

**Create Post Screen**3. No arquivo `lib/main.dart`, substitua:

- Text editor   ```dart

- Upload de imagens   await Supabase.initialize(

- Preview     url: 'YOUR_SUPABASE_URL',

- Botão publicar     anonKey: 'YOUR_SUPABASE_ANON_KEY',

   );

### 3️⃣ Busca & Estabelecimentos   ```

**Search Screen**

- Campo de busca### 3. Execute o Schema SQL

- Filtros (categoria, distância, rating)

- Lista de estabelecimentos1. Acesse o SQL Editor do Supabase

- Mapa (opcional)2. Cole o conteúdo de `SUPABASE_SCHEMA.sql`

3. Execute para criar todas as tabelas, índices e policies

**Establishment Detail Screen**

- Nome, descrição, imagem### 4. Instale Dependências

- Rating e reviews

- Serviços/Itens oferecidos```bash

- Horário de funcionamentoflutter pub get

- Botão para reservar/pedir```



### 4️⃣ Perfil### 5. Execute o App

**Profile Screen**

- Avatar```bash

- Nome, usernameflutter run

- Bio```

- Estatísticas (seguidores, posts)

- Botão "Editar Perfil"---

- Logout

## 📱 Fluxos Principais (User Stories)

**Edit Profile Screen**

- Editar nome, bio### 1. Autenticação & Registro

- Mudar avatar

- Salvar**Fluxo de Registro:**

```

### 5️⃣ Pedidos & ReservasSplash Screen 

**Orders Screen**  ↓

- Filtro por statusLogin Screen (com "Criar Conta")

- Lista de pedidos  ↓

- Detalhes por pedidoRegister Screen (Escolher: Usuário ou Parceiro)

  ↓

**Reservations Screen**Sign Up (Supabase Auth)

- Filtro por status  ↓

- Lista de reservasRedirect para Home

- Detalhes por reserva```



---### 2. Buscar Estabelecimentos



## 🚀 Como Executar**Fluxo:**

```

### Pré-requisitosHome

```bash  ↓

# FlutterSearch Screen (por nome, categoria, localização)

flutter --version          # 3.24.0 ou superior  ↓

Estabelecimentos Listados (com rating, distância)

# Verificar ambiente  ↓

flutter doctor             # Deve estar tudo OKClicar em Estabelecimento

  ↓

# Android/iOS/Windows SDKDetail Screen (menu, reviews, opções de reserva/delivery)

# (Já configurado no seu projeto)```

```

### 3. Fazer Reserva (Quartos)

### Instalação

```bash**Fluxo:**

# Ir para pasta do projeto```

cd "c:\Users\Bruno\Desktop\base app\rede"Establishment Detail

  ↓

# Instalar dependênciasClicar em "Reservar Quarto"

flutter pub get  ↓

Rooms List (tipos, preço, disponibilidade)

# Limpar build anterior  ↓

flutter cleanSelecionar Check-in/Check-out

  ↓

# ExecutarConfirmação de Disponibilidade

flutter run -d windows  ↓

```Review & Pagamento

  ↓

### Executar em Outros DispositivosConfirmação de Reserva

```bash```

# Android

flutter run -d android### 4. Fazer Pedido (Delivery)



# iOS (macOS)**Fluxo:**

flutter run -d ios```

Establishment Detail

# Web  ↓

flutter run -d webMenu Items Listados

  ↓

# LinuxAdicionar ao Carrinho

flutter run -d linux  ↓

```Carrinho Screen (editar quantidades)

  ↓

---Checkout (endereço delivery, observações)

  ↓

## 📊 Status de DesenvolvimentoSeleção de Pagamento

  ↓

### Fase 1: ✅ COMPLETOConfirmação do Pedido

- [x] Backend services  ↓

- [x] Database schemaRastreamento em Tempo Real

- [x] Storage buckets```

- [x] Autenticação configurada

- [x] Providers Riverpod### 5. Feed Social



### Fase 2: 🔨 EM PROGRESSO**Fluxo:**

- [ ] Login screen```

- [ ] Register screenHome (Tab: Feed)

- [ ] Home feed screen  ↓

- [ ] Search screenPosts em Tempo Real (Supabase Stream)

- [ ] Profile screen  ↓

- [ ] Orders screenInterações: Like, Comentar, Compartilhar

- [ ] Reservations screen  ↓

Clicar em Perfil do Autor

### Fase 3: ⏳ PLANEJADO  ↓

- [ ] Comentários em postsProfile Screen (avatar, bio, posts do usuário)

- [ ] Curtir posts```

- [ ] Seguir usuários

- [ ] Chat direto---

- [ ] Notificações push

- [ ] Pagamentos## 💻 Exemplos de Código

- [ ] Busca avançada

- [ ] Dark mode### 1. Autenticação (usando SupabaseService)



---```dart

// lib/core/services/supabase_service.dart

## 🔗 Recursos Úteisfinal supabaseService = SupabaseService();



### Documentação// Registro

- [Flutter Docs](https://flutter.dev/docs)await supabaseService.signUp(

- [Riverpod Docs](https://riverpod.dev)  email: 'user@example.com',

- [Supabase Flutter](https://supabase.com/docs/reference/flutter/introduction)  password: 'password123',

- [Go Router Docs](https://pub.dev/documentation/go_router/latest/)  fullName: 'João Silva',

  userType: 'user', // ou 'partner'

### Credenciais Supabase);

```

URL: https://fgjkuuewrclnxawpovtw.supabase.co// Login

Projeto: fgjkuuewrclnxawpovtwawait supabaseService.signIn(

Dashboard: https://app.supabase.com/  email: 'user@example.com',

```  password: 'password123',

);

### Tabelas Disponíveis```

- users, establishments, services, rooms, room_availability

- reservations, menu_items, orders, order_items### 2. Buscar Estabelecimentos

- posts, comments, likes, events, tickets

- reviews, follows, notifications, payments```dart

// Busca full-text

---final results = await supabaseService.searchEstablishments('pizza');



## 📝 Notas Importantes// Busca por localização

final nearby = await supabaseService.getNearbyEstablishments(

### Configuração Supabase  latitude: -23.5505,

✅ Credenciais ja estão no `main.dart`  longitude: -46.6333,

✅ RLS policies já configuradas  radiusKm: 5,

✅ Storage buckets já criados);

✅ Database schema já executado```



### Variáveis de Ambiente### 3. Criar Post com Imagem

Não use variáveis de ambiente no pubspec.yaml, as credenciais ja estão hardcoded em `main.dart` (desenvolvimento).

```dart

Para produção, usar:final imageUrl = await supabaseService.uploadPostImage('/path/to/image.jpg');

```dartfinal postId = await supabaseService.createPost(

// .env  content: 'Adorei esse restaurante!',

SUPABASE_URL=...  imageUrls: [imageUrl],

SUPABASE_ANON_KEY=...  isPublic: true,

```);

```

---

### 4. Fazer Reserva de Quarto

## 🤝 Contribuição

```dart

Este é um projeto pessoal em desenvolvimento. Para melhorias:final reservationId = await supabaseService.createReservation(

1. Testar telas antes de commitar  establishmentId: 'hotel-123',

2. Manter padrão de código (formatter)  reservationType: 'room',

3. Adicionar comentários em lógica complexa  roomId: 'room-456',

4. Atualizar este README  checkInDate: DateTime(2025, 12, 15),

  checkOutDate: DateTime(2025, 12, 20),

---  numberOfGuests: 2,

  totalPrice: 1500.00,

## 📞 Suporte);

```

Dúvidas sobre as telas ou funcionalidades? Verifique:

1. Console do VS Code (erros)### 5. Fazer Pedido (Delivery)

2. Logs do Supabase (backend)

3. Documentação de cada ViewModel```dart

final orderId = await supabaseService.createOrder(

---  establishmentId: 'restaurant-123',

  orderType: 'delivery',

**Versão**: 1.0.0    totalPrice: 89.90,

**Última atualização**: 17 de novembro de 2025    deliveryAddress: 'Rua X, 123, São Paulo, SP',

**Status**: Pronto para frontend  specialInstructions: 'Sem cebola, por favor',

);

// Rastrear pedido em tempo real (usando stream)
final orderStream = supabaseService.client
    .from('orders')
    .stream(primaryKey: ['id'])
    .eq('id', orderId);
```

### 6. Usar Riverpod para Estado

```dart
// lib/providers/user_provider.dart
final currentUserProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final supabase = SupabaseService();
  if (supabase.isAuthenticated) {
    return await supabase.getCurrentUserData();
  }
  return null;
});

// Usar na UI
@override
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(currentUserProvider);
  
  return user.when(
    data: (data) => Text('Olá, ${data?['full_name']}'),
    loading: () => CircularProgressIndicator(),
    error: (err, stack) => Text('Erro: $err'),
  );
}
```

---

## 🎯 Roadmap de Desenvolvimento

### Fase 1: MVP (Semanas 1-4)
- [x] Setup inicial do projeto Supabase
- [ ] Autenticação (Sign Up, Login, Logout)
- [ ] Tela de Perfil (criar/editar)
- [ ] Busca de estabelecimentos (full-text + geo)
- [ ] Detail screen de estabelecimento
- [ ] Feed social básico (posts, likes, comentários)

### Fase 2: Reservas (Semanas 5-6)
- [ ] Listagem de quartos
- [ ] Verificação de disponibilidade
- [ ] Fluxo de reserva (checkout, pagamento mock)
- [ ] Minhas reservas screen

### Fase 3: Delivery (Semanas 7-8)
- [ ] Menu items e carrinho de compras
- [ ] Checkout de pedidos
- [ ] Rastreamento em tempo real
- [ ] Histórico de pedidos

### Fase 4: Eventos & Polimentos (Semanas 9+)
- [ ] Eventos e venda de ingressos
- [ ] Notificações push
- [ ] Rating/reviews
- [ ] Testes e otimizações

---

## 🔐 Segurança

### Row Level Security (RLS)
Todas as tabelas têm RLS habilitada e policies configuradas para:
- Usuários só acessam seus dados privados
- Dados públicos (posts, estabelecimentos) são vísíveis
- Parceiros veem dados de seus estabelecimentos

### Autenticação
- Supabase Auth com JWT
- Senhas hasheadas no banco
- Sessions mantidas automaticamente

---

## 📊 Performance & Otimizações

- **Índices**: Criados em colunas de busca frequente (email, username, categoria, cidade, rating)
- **Full-text Search**: Implementado para estabelecimentos e posts
- **Geosearch**: Usando função `earth_distance` do PostGIS
- **Realtime**: Supabase Streams para feed social e rastreamento de pedidos
- **Caching**: `cached_network_image` para imagens
- **Lazy Loading**: Paginação em listas (offset/limit)

---

## 🐛 Troubleshooting

### "Supabase not initialized"
- Certifique-se de que `main.dart` chama `Supabase.initialize()` antes de `runApp()`

### "RLS policy violation"
- Verifique que o usuário está autenticado (`currentUser != null`)
- Confirme que as policies estão corretas no Supabase

### Imagens não carregam
- Verifique que Storage buckets estão públicos
- Confirme que URLs de Storage estão corretas

---

## 📚 Referências

- [Supabase Docs](https://supabase.com/docs)
- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Docs](https://riverpod.dev)
- [Go Router Docs](https://pub.dev/packages/go_router)

---

## 👥 Contribuidores

- Bruno (Product Owner & Lead Dev)

---

## 📄 Licença

MIT License - veja arquivo LICENSE

---

**Última atualização:** 17 de novembro de 2025
