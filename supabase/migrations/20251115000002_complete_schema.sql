-- ============================================================================
-- REDE Project - Complete Database Schema (Consolidated)
-- Date: 15 de novembro de 2025
-- Description: All migrations consolidated into a single file
-- ============================================================================

-- ============================================================================
-- 1. EXTENSIONS
-- ============================================================================
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================================================================
-- 2. TABLES
-- ============================================================================

-- Profiles: Consumers and Partners
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid PRIMARY KEY DEFAULT auth.uid(),
  role text CHECK (role IN ('consumer','partner')),
  name text,
  avatar text,
  phone text,
  fcm_token text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- Establishments: Restaurants, bars, hotels, event venues, suppliers
CREATE TABLE IF NOT EXISTS public.establishments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  name text NOT NULL,
  type text,
  address_json jsonb,
  location_point geometry(point, 4326),
  services_json jsonb,
  rating numeric(3,1),
  photos text[],
  created_at timestamp with time zone DEFAULT now()
);

-- Menu items for establishments
CREATE TABLE IF NOT EXISTS public.menu_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  establishment_id uuid NOT NULL REFERENCES public.establishments (id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  price numeric(12,2) NOT NULL,
  image_url text,
  available boolean DEFAULT true,
  created_at timestamp with time zone DEFAULT now()
);

-- Orders from consumers
CREATE TABLE IF NOT EXISTS public.orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  establishment_id uuid NOT NULL REFERENCES public.establishments (id) ON DELETE CASCADE,
  user_id uuid REFERENCES public.profiles (id) ON DELETE SET NULL,
  consumer_id uuid REFERENCES public.profiles (id) ON DELETE SET NULL,
  status text CHECK (status IN ('pending','accepted','rejected','preparing','ready','delivered')) DEFAULT 'pending',
  items jsonb NOT NULL,
  total numeric(12,2) NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);

-- Table reservations
CREATE TABLE IF NOT EXISTS public.table_reservations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  establishment_id uuid NOT NULL REFERENCES public.establishments (id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  reserved_for timestamp with time zone NOT NULL,
  party_size int NOT NULL,
  status text CHECK (status IN ('requested','confirmed','cancelled')) DEFAULT 'requested',
  created_at timestamp with time zone DEFAULT now()
);

-- Events (concerts, parties, etc)
CREATE TABLE IF NOT EXISTS public.events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  establishment_id uuid NOT NULL REFERENCES public.establishments (id) ON DELETE CASCADE,
  name text NOT NULL,
  date timestamp with time zone,
  price numeric(12,2),
  total_tickets int,
  sold_tickets int DEFAULT 0,
  created_at timestamp with time zone DEFAULT now()
);

-- Event ticket purchases
CREATE TABLE IF NOT EXISTS public.ticket_purchases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id uuid NOT NULL REFERENCES public.events (id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  quantity int NOT NULL,
  total numeric(12,2) NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);

-- Room/Hotel bookings
CREATE TABLE IF NOT EXISTS public.room_bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  establishment_id uuid NOT NULL REFERENCES public.establishments (id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  check_in date,
  check_out date,
  guests int,
  status text CHECK (status IN ('requested','confirmed','cancelled')) DEFAULT 'requested',
  created_at timestamp with time zone DEFAULT now()
);

-- Indications (recommendations between users)
CREATE TABLE IF NOT EXISTS public.indications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  target_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  message text,
  created_at timestamp with time zone DEFAULT now()
);

-- Posts (feed)
CREATE TABLE IF NOT EXISTS public.posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id uuid NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  establishment_id uuid REFERENCES public.establishments (id) ON DELETE SET NULL,
  content text,
  images jsonb,
  likes int DEFAULT 0,
  created_at timestamp with time zone DEFAULT now()
);

-- ============================================================================
-- 3. ADD MISSING COLUMNS (Safety checks)
-- ============================================================================

-- Profiles
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS fcm_token text,
ADD COLUMN IF NOT EXISTS updated_at timestamp with time zone DEFAULT now();

-- Establishments
ALTER TABLE public.establishments
ADD COLUMN IF NOT EXISTS rating numeric(3,1),
ADD COLUMN IF NOT EXISTS photos text[];

-- Menu items
ALTER TABLE public.menu_items
ADD COLUMN IF NOT EXISTS available boolean DEFAULT true,
ADD COLUMN IF NOT EXISTS image_url text;

-- Orders
ALTER TABLE public.orders
ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES public.profiles(id) ON DELETE SET NULL;

-- Events
ALTER TABLE public.events
ADD COLUMN IF NOT EXISTS name text,
ADD COLUMN IF NOT EXISTS date timestamp with time zone;

-- Garantir que a coluna date existe (correção para tabelas já criadas)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'events' 
    AND column_name = 'date'
  ) THEN
    ALTER TABLE public.events ADD COLUMN date timestamp with time zone;
  END IF;
END $$;

-- Room bookings
ALTER TABLE public.room_bookings
ADD COLUMN IF NOT EXISTS guests int;

-- Posts
ALTER TABLE public.posts
ADD COLUMN IF NOT EXISTS establishment_id uuid REFERENCES public.establishments(id) ON DELETE SET NULL;

-- Indications
-- Garantir que a coluna id existe (sem tentar criar PRIMARY KEY se já existe)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'indications' 
    AND column_name = 'id'
  ) THEN
    ALTER TABLE public.indications ADD COLUMN id uuid DEFAULT gen_random_uuid();
    -- Só adiciona PRIMARY KEY se não existir
    IF NOT EXISTS (
      SELECT 1 FROM pg_constraint 
      WHERE conname = 'indications_pkey'
    ) THEN
      ALTER TABLE public.indications ADD PRIMARY KEY (id);
    END IF;
  END IF;
END $$;

-- ============================================================================
-- 4. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "profiles read own" ON public.profiles;
DROP POLICY IF EXISTS "profiles insert self" ON public.profiles;
DROP POLICY IF EXISTS "profiles update own" ON public.profiles;
CREATE POLICY "profiles read own" ON public.profiles FOR SELECT USING (id = auth.uid());
CREATE POLICY "profiles insert self" ON public.profiles FOR INSERT WITH CHECK (id = auth.uid());
CREATE POLICY "profiles update own" ON public.profiles FOR UPDATE USING (id = auth.uid());

-- Establishments
ALTER TABLE public.establishments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "establishments public read" ON public.establishments;
DROP POLICY IF EXISTS "establishments owner insert" ON public.establishments;
DROP POLICY IF EXISTS "establishments owner update" ON public.establishments;
DROP POLICY IF EXISTS "establishments owner delete" ON public.establishments;
CREATE POLICY "establishments public read" ON public.establishments FOR SELECT USING (true);
CREATE POLICY "establishments owner insert" ON public.establishments FOR INSERT WITH CHECK (owner_id = auth.uid());
CREATE POLICY "establishments owner update" ON public.establishments FOR UPDATE USING (owner_id = auth.uid());
CREATE POLICY "establishments owner delete" ON public.establishments FOR DELETE USING (owner_id = auth.uid());

-- Menu items
ALTER TABLE public.menu_items ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "menu items public read" ON public.menu_items;
DROP POLICY IF EXISTS "menu items owner write" ON public.menu_items;
DROP POLICY IF EXISTS "menu items owner update" ON public.menu_items;
DROP POLICY IF EXISTS "menu items owner delete" ON public.menu_items;
CREATE POLICY "menu items public read" ON public.menu_items FOR SELECT USING (true);
CREATE POLICY "menu items owner write" ON public.menu_items FOR INSERT WITH CHECK (
  EXISTS(SELECT 1 FROM public.establishments e WHERE e.id = menu_items.establishment_id AND e.owner_id = auth.uid())
);
CREATE POLICY "menu items owner update" ON public.menu_items FOR UPDATE USING (
  EXISTS(SELECT 1 FROM public.establishments e WHERE e.id = menu_items.establishment_id AND e.owner_id = auth.uid())
);
CREATE POLICY "menu items owner delete" ON public.menu_items FOR DELETE USING (
  EXISTS(SELECT 1 FROM public.establishments e WHERE e.id = menu_items.establishment_id AND e.owner_id = auth.uid())
);

-- Orders
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "orders consumer read own" ON public.orders;
DROP POLICY IF EXISTS "orders consumer write own" ON public.orders;
DROP POLICY IF EXISTS "orders partner read establishment" ON public.orders;
DROP POLICY IF EXISTS "orders partner update establishment" ON public.orders;
CREATE POLICY "orders consumer read own" ON public.orders FOR SELECT USING (consumer_id = auth.uid());
CREATE POLICY "orders consumer write own" ON public.orders FOR INSERT WITH CHECK (consumer_id = auth.uid());
CREATE POLICY "orders partner read establishment" ON public.orders FOR SELECT USING (
  EXISTS(SELECT 1 FROM public.establishments e WHERE e.id = orders.establishment_id AND e.owner_id = auth.uid())
);
CREATE POLICY "orders partner update establishment" ON public.orders FOR UPDATE USING (
  EXISTS(SELECT 1 FROM public.establishments e WHERE e.id = orders.establishment_id AND e.owner_id = auth.uid())
);

-- Table reservations
ALTER TABLE public.table_reservations ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "reservations consumer read own" ON public.table_reservations;
DROP POLICY IF EXISTS "reservations consumer write own" ON public.table_reservations;
DROP POLICY IF EXISTS "reservations partner read establishment" ON public.table_reservations;
DROP POLICY IF EXISTS "reservations partner update establishment" ON public.table_reservations;
CREATE POLICY "reservations consumer read own" ON public.table_reservations FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "reservations consumer write own" ON public.table_reservations FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "reservations partner read establishment" ON public.table_reservations FOR SELECT USING (
  EXISTS(SELECT 1 FROM public.establishments e WHERE e.id = table_reservations.establishment_id AND e.owner_id = auth.uid())
);
CREATE POLICY "reservations partner update establishment" ON public.table_reservations FOR UPDATE USING (
  EXISTS(SELECT 1 FROM public.establishments e WHERE e.id = table_reservations.establishment_id AND e.owner_id = auth.uid())
);

-- Events
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "events public read" ON public.events;
DROP POLICY IF EXISTS "events partner write" ON public.events;
DROP POLICY IF EXISTS "events partner update" ON public.events;
CREATE POLICY "events public read" ON public.events FOR SELECT USING (true);
CREATE POLICY "events partner write" ON public.events FOR INSERT WITH CHECK (
  EXISTS(SELECT 1 FROM public.establishments e WHERE e.id = events.establishment_id AND e.owner_id = auth.uid())
);
CREATE POLICY "events partner update" ON public.events FOR UPDATE USING (
  EXISTS(SELECT 1 FROM public.establishments e WHERE e.id = events.establishment_id AND e.owner_id = auth.uid())
);

-- Ticket purchases
ALTER TABLE public.ticket_purchases ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "tickets consumer read own" ON public.ticket_purchases;
DROP POLICY IF EXISTS "tickets consumer insert own" ON public.ticket_purchases;
DROP POLICY IF EXISTS "tickets partner read event" ON public.ticket_purchases;
CREATE POLICY "tickets consumer read own" ON public.ticket_purchases FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "tickets consumer insert own" ON public.ticket_purchases FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "tickets partner read event" ON public.ticket_purchases FOR SELECT USING (
  EXISTS(SELECT 1 FROM public.events ev JOIN public.establishments e ON ev.establishment_id = e.id WHERE ev.id = ticket_purchases.event_id AND e.owner_id = auth.uid())
);

-- Room bookings
ALTER TABLE public.room_bookings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "bookings consumer read own" ON public.room_bookings;
DROP POLICY IF EXISTS "bookings consumer insert own" ON public.room_bookings;
DROP POLICY IF EXISTS "bookings partner read establishment" ON public.room_bookings;
CREATE POLICY "bookings consumer read own" ON public.room_bookings FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "bookings consumer insert own" ON public.room_bookings FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "bookings partner read establishment" ON public.room_bookings FOR SELECT USING (
  EXISTS(SELECT 1 FROM public.establishments e WHERE e.id = room_bookings.establishment_id AND e.owner_id = auth.uid())
);

-- Indications
ALTER TABLE public.indications ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "indications consumer read own" ON public.indications;
DROP POLICY IF EXISTS "indications consumer insert own" ON public.indications;
CREATE POLICY "indications consumer read own" ON public.indications FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "indications consumer insert own" ON public.indications FOR INSERT WITH CHECK (user_id = auth.uid());

-- Posts
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "posts public read" ON public.posts;
DROP POLICY IF EXISTS "posts author write" ON public.posts;
DROP POLICY IF EXISTS "posts author update" ON public.posts;
CREATE POLICY "posts public read" ON public.posts FOR SELECT USING (true);
CREATE POLICY "posts author write" ON public.posts FOR INSERT WITH CHECK (author_id = auth.uid());
CREATE POLICY "posts author update" ON public.posts FOR UPDATE USING (author_id = auth.uid());

-- ============================================================================
-- 5. VIEWS
-- ============================================================================

CREATE OR REPLACE VIEW public.current_user_role AS
  SELECT p.id AS user_id, p.role FROM public.profiles p WHERE p.id = auth.uid();

-- ============================================================================
-- 6. INDEXES (Performance optimization)
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_establishments_location ON public.establishments USING gist(location_point);
CREATE INDEX IF NOT EXISTS idx_establishments_owner ON public.establishments (owner_id);
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON public.posts (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_posts_author ON public.posts (author_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON public.orders (status);
CREATE INDEX IF NOT EXISTS idx_orders_consumer ON public.orders (consumer_id);
CREATE INDEX IF NOT EXISTS idx_orders_establishment ON public.orders (establishment_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_establishment ON public.menu_items (establishment_id);
CREATE INDEX IF NOT EXISTS idx_profiles_fcm_token ON public.profiles (fcm_token) WHERE fcm_token IS NOT NULL;

-- ============================================================================
-- 7. FUNCTIONS (PostGIS e outras)
-- ============================================================================

-- Função para buscar estabelecimentos próximos usando PostGIS
CREATE OR REPLACE FUNCTION public.nearby_establishments(
  lat double precision,
  lng double precision,
  radius_meters double precision DEFAULT 5000
)
RETURNS TABLE (
  id uuid,
  owner_id uuid,
  name text,
  type text,
  address_json jsonb,
  location_point geometry,
  services_json jsonb,
  rating numeric,
  photos text[],
  created_at timestamp with time zone,
  distance_meters double precision
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.id,
    e.owner_id,
    e.name,
    e.type,
    e.address_json,
    e.location_point,
    e.services_json,
    e.rating,
    e.photos,
    e.created_at,
    ST_Distance(
      e.location_point::geography,
      ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography
    ) AS distance_meters
  FROM public.establishments e
  WHERE e.location_point IS NOT NULL
    AND ST_DWithin(
      e.location_point::geography,
      ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography,
      radius_meters
    )
  ORDER BY distance_meters;
END;
$$;

-- ============================================================================
-- Schema consolidated successfully!
-- ============================================================================

