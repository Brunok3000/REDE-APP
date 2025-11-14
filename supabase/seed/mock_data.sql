-- mock_data.sql
-- Dados de exemplo para o projeto rede (idempotente)
-- Seed robusto com UUIDs fixos e ON CONFLICT DO NOTHING

-- Profiles (consumers)
INSERT INTO public.profiles (id, role, name, phone, created_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'consumer', 'Alice Consumer', '+5511999000001', now()),
  ('22222222-2222-2222-2222-222222222222', 'consumer', 'Bob Consumer', '+5511999000002', now())
ON CONFLICT (id) DO NOTHING;

-- Profiles (partners)
INSERT INTO public.profiles (id, role, name, phone, created_at)
VALUES
  ('33333333-3333-3333-3333-333333333333', 'partner', 'Carol Partner', '+5511999000101', now()),
  ('44444444-4444-4444-4444-444444444444', 'partner', 'Dave Partner', '+5511999000102', now()),
  ('55555555-5555-5555-5555-555555555555', 'partner', 'Eve Partner', '+5511999000103', now())
ON CONFLICT (id) DO NOTHING;

-- Establishments (fixed UUIDs tied to partner owners)
INSERT INTO public.establishments (id, owner_id, name, type, address_json, location_point, services_json, rating, photos, created_at)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000001', '33333333-3333-3333-3333-333333333333', 'Bar do Centro', 'bar', '{"street":"Endereco 1","city":"Sao Paulo"}'::jsonb, ST_SetSRID(ST_Point(-46.61, -23.51), 4326), '[]'::jsonb, NULL, NULL, now()),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000002', '44444444-4444-4444-4444-444444444444', 'Restaurante Bom Sabor', 'restaurant', '{"street":"Endereco 2","city":"Sao Paulo"}'::jsonb, ST_SetSRID(ST_Point(-46.62, -23.52), 4326), '[]'::jsonb, NULL, NULL, now()),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000003', '55555555-5555-5555-5555-555555555555', 'Hotel Tranquilo', 'hotel', '{"street":"Endereco 3","city":"Sao Paulo"}'::jsonb, ST_SetSRID(ST_Point(-46.63, -23.53), 4326), '[]'::jsonb, NULL, NULL, now()),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000004', '33333333-3333-3333-3333-333333333333', 'Salao de Eventos', 'event', '{"street":"Endereco 4","city":"Sao Paulo"}'::jsonb, ST_SetSRID(ST_Point(-46.64, -23.54), 4326), '[]'::jsonb, NULL, NULL, now()),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000005', '44444444-4444-4444-4444-444444444444', 'Fornecedor X', 'supplier', '{"street":"Endereco 5","city":"Sao Paulo"}'::jsonb, ST_SetSRID(ST_Point(-46.65, -23.55), 4326), '[]'::jsonb, NULL, NULL, now())
ON CONFLICT (id) DO NOTHING;

-- Menu items: 10 items distributed across establishments
INSERT INTO public.menu_items (id, establishment_id, name, price, description, available, created_at)
VALUES
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'Cerveja Premium', 25.90, 'Cerveja gelada importada', true, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'Chopp Artesanal', 18.50, 'Chopp da casa', true, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'Carne Grelhada', 55.00, 'Carne vermelha premium', true, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'Frango Assado', 35.00, 'Frango temperado especial', true, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'Salmao Grelhado', 45.00, 'Salmao fresco', true, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'Suite Executiva', 150.00, 'Quarto com vista privilegiada', true, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'Quarto Duplo', 95.00, 'Quarto confortavel', true, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'Ingresso Festival', 80.00, 'Acesso ao festival completo', true, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000005', 'Fornecimento Mensal', 2500.00, 'Contrato B2B mensal', true, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'Petiscos Variados', 42.00, 'Mix de petiscos da casa', true, now())
ON CONFLICT (id) DO NOTHING;

-- Events: 5 events
INSERT INTO public.events (id, establishment_id, name, date, price, total_tickets, sold_tickets, created_at)
VALUES
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'Festa de Abertura', now() + interval '5 days', 50.00, 100, 25, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'Show Ao Vivo', now() + interval '10 days', 75.00, 150, 60, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'DJ Night', now() + interval '15 days', 40.00, 200, 100, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'Workshop Gastro', now() + interval '20 days', 120.00, 50, 30, now()),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'Networking Empresarial', now() + interval '25 days', 99.00, 80, 45, now())
ON CONFLICT (id) DO NOTHING;

-- Room bookings: 3 reservas
INSERT INTO public.room_bookings (id, user_id, establishment_id, check_in, check_out, guests, status, created_at)
VALUES
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', '2025-12-01', '2025-12-05', 2, 'confirmed', now()),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', '2025-12-10', '2025-12-12', 1, 'requested', now()),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', '2025-12-20', '2025-12-22', 3, 'confirmed', now())
ON CONFLICT (id) DO NOTHING;

-- Posts: 10 posts no feed
INSERT INTO public.posts (id, author_id, establishment_id, content, images, likes, created_at)
VALUES
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'Cerveja gelada eh tudo que preciso!', '["https://placehold.co/800x600"]'::jsonb, 12, now() - interval '7 days'),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'Melhor carne da cidade', '["https://placehold.co/800x600"]'::jsonb, 8, now() - interval '6 days'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'Hotel maravilhoso, voltarei com certeza', '["https://placehold.co/800x600"]'::jsonb, 15, now() - interval '5 days'),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'Festival incrivel, nao percam!', '["https://placehold.co/800x600"]'::jsonb, 22, now() - interval '4 days'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'Happy hour todo dia 5pm', '["https://placehold.co/800x600"]'::jsonb, 5, now() - interval '3 days'),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'Frango assado divino', '["https://placehold.co/800x600"]'::jsonb, 19, now() - interval '2 days'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'Spa do hotel eh perfeito', '["https://placehold.co/800x600"]'::jsonb, 7, now() - interval '1 day'),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'Ingressos disponiveis para show!', '["https://placehold.co/800x600"]'::jsonb, 31, now()),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', NULL, 'Conheci gente legal na rede hoje!', '["https://placehold.co/800x600"]'::jsonb, 3, now()),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', NULL, 'Alguem mais ama comida?', '["https://placehold.co/800x600"]'::jsonb, 9, now())
ON CONFLICT (id) DO NOTHING;

-- Indications: 5 recomendacoes (usa chave composta user_id, target_id)
INSERT INTO public.indications (user_id, target_id, message, created_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333', 'Carol eh excelente parceira de negocio', now()),
  ('11111111-1111-1111-1111-111111111111', '44444444-4444-4444-4444-444444444444', 'Dave tem os melhores pratos', now()),
  ('22222222-2222-2222-2222-222222222222', '55555555-5555-5555-5555-555555555555', 'Eve fornece produtos de qualidade', now()),
  ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333', 'Carol eh confiavel demais', now()),
  ('11111111-1111-1111-1111-111111111111', '55555555-5555-5555-5555-555555555555', 'Eve sempre atenciosa', now())
ON CONFLICT (user_id, target_id) DO NOTHING;

-- Orders: 3 pedidos
INSERT INTO public.orders (id, user_id, establishment_id, consumer_id, items, total, status, created_at)
VALUES
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', '11111111-1111-1111-1111-111111111111', '[{"name":"Cerveja Premium","qty":2,"price":25.90}]'::jsonb, 51.80, 'delivered', now() - interval '2 days'),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', '22222222-2222-2222-2222-222222222222', '[{"name":"Carne Grelhada","qty":1,"price":55.00}]'::jsonb, 55.00, 'ready', now() - interval '1 day'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', '11111111-1111-1111-1111-111111111111', '[{"name":"Petiscos Variados","qty":1,"price":42.00}]'::jsonb, 42.00, 'pending', now())
ON CONFLICT (id) DO NOTHING;

