# Contrato de Dados (MVP)

Este documento descreve o contrato mínimo de dados para a aplicação: entidades, campos essenciais, regras de negócio e permissões iniciais.

## Entidades principais

- User
  - id: string (UUID)
  - name: string
  - email: string
  - avatarUrl: string? (URL)
  - role: "user" | "partner"
  - createdAt: ISO datetime
  - settings: object
    - optOutProfileVisits: bool

- PartnerProfile
  - id: string (UUID)
  - userId: string (ref User)
  - name: string
  - description: string
  - types: array of EstablishmentType (ex: hotel, restaurant, service)
  - active: bool
  - address: string
  - geo: { lat: number, lng: number }
  - hours: structured string or JSON
  - gallery: array of image URLs
  - contact: { phone, email, website }
  - verificationStatus: string (unverified/verified)

- EstablishmentType
  - enum values: hotel, restaurant, service, store, event_space, other

- Room
  - id, partnerId, title, description, photos, price, capacity, availability (calendar)

- MenuItem
  - id, partnerId, title, description, price, photos, tags

- Reservation / Order
  - id, userId, partnerId, items, total, status, createdAt, dates

- CheckIn
  - id, userId, partnerId, createdAt

- Testimonial
  - id, authorId, targetUserId, content, isSecret, approved, createdAt, reply

- Rating
  - id, raterId, targetUserId, category (legal/sexy/confiavel), value, createdAt

- ProfileVisit
  - id, visitorId (nullable), visitedUserId, createdAt

## Regras de negócio importantes

- Conta Parceiro não exige CNPJ/CPF no MVP. O que diferencia é o conjunto de campos de perfil e páginas de serviço (quando ativadas).
- Depoimentos (Testimonial) ficam pendentes (`approved=false`) até que o dono do perfil aprove. O dono pode aprovar, remover ou responder.
- Profile visits são registrados por padrão; o usuário pode optar por `optOutProfileVisits` e então detalhes não serão armazenados (apenas a contagem, se desejado).
- Check-ins: só é permitido um novo check-in no mesmo estabelecimento pelo mesmo usuário após 24 horas do check-in anterior.
- Parceiros podem ter múltiplos tipos, mas priorizaremos features do ramo principal no MVP (ex: restaurante -> reservar mesa / vender delivery).

## API / Persistência (MVP)

- Inicialmente usaremos repositórios mock locais durante o desenvolvimento. Quando integrar ao Supabase, mapear as entidades acima para tabelas equivalentes.
- Nunca comitar chaves ou service_role keys no repositório. Use variáveis de ambiente e recomendações de segurança.

## Observações

- Log de visitas e depoimentos permitem remoção por solicitação do usuário (LGPD/Lawful requests).
- Lógica de moderação leve: dono do perfil aprova depoimentos secretos. Podemos adicionar painel de moderação global mais tarde.

---
Documento gerado automaticamente como artefato inicial para o MVP. Atualize conforme necessidades futuras.
