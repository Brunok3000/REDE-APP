-- ============================================================================
-- SCHEMA DO SUPABASE PARA APP "REDE"
-- MVP: Rede Social + Busca de Estabelecimentos + Reservas + Delivery + Eventos
-- ============================================================================

-- ============================================================================
-- 1. TABELA DE USUÁRIOS (Users)
-- ============================================================================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  username TEXT UNIQUE,
  bio TEXT,
  avatar_url TEXT,
  phone_number TEXT,
  document_number TEXT,
  user_type TEXT CHECK (user_type IN ('user', 'partner')),
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT username_length CHECK (LENGTH(username) >= 3)
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_user_type ON users(user_type);

-- ============================================================================
-- 2. TABELA DE ESTABELECIMENTOS (Establishments)
-- ============================================================================
CREATE TABLE IF NOT EXISTS establishments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  partner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  logo_url TEXT,
  cover_image_url TEXT,
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  zip_code TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  phone TEXT,
  email TEXT,
  website TEXT,
  rating DECIMAL(3, 2) DEFAULT 0.00,
  total_reviews INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  offers_delivery BOOLEAN DEFAULT FALSE,
  offers_reservation BOOLEAN DEFAULT FALSE,
  offers_events BOOLEAN DEFAULT FALSE,
  offers_services BOOLEAN DEFAULT FALSE,
  opening_time TIME,
  closing_time TIME,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_establishments_partner_id ON establishments(partner_id);
CREATE INDEX idx_establishments_category ON establishments(category);
CREATE INDEX idx_establishments_city ON establishments(city);
CREATE INDEX idx_establishments_rating ON establishments(rating DESC);

ALTER TABLE establishments ADD COLUMN search_vector tsvector;
CREATE INDEX idx_establishments_search ON establishments USING gin(search_vector);

-- ============================================================================
-- 3. TABELA DE SERVIÇOS (Services)
-- ============================================================================
CREATE TABLE IF NOT EXISTS services (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  establishment_id UUID NOT NULL REFERENCES establishments(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  duration_minutes INTEGER,
  base_price DECIMAL(10, 2),
  category TEXT,
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_services_establishment_id ON services(establishment_id);
CREATE INDEX idx_services_category ON services(category);

-- ============================================================================
-- 4. TABELA DE QUARTOS (Rooms)
-- ============================================================================
CREATE TABLE IF NOT EXISTS rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  establishment_id UUID NOT NULL REFERENCES establishments(id) ON DELETE CASCADE,
  room_number TEXT NOT NULL,
  room_type TEXT NOT NULL,
  capacity INTEGER DEFAULT 1,
  price_per_night DECIMAL(10, 2),
  amenities TEXT[],
  total_rooms INTEGER DEFAULT 1,
  available_rooms INTEGER DEFAULT 1,
  description TEXT,
  room_images TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_rooms_establishment_id ON rooms(establishment_id);
CREATE INDEX idx_rooms_room_type ON rooms(room_type);

-- ============================================================================
-- 5. TABELA DE DISPONIBILIDADE DE QUARTOS (Room Availability)
-- ============================================================================
CREATE TABLE IF NOT EXISTS room_availability (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
  available_date DATE NOT NULL,
  available_count INTEGER DEFAULT 1,
  UNIQUE(room_id, available_date),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_room_availability_room_id ON room_availability(room_id);
CREATE INDEX idx_room_availability_date ON room_availability(available_date);

-- ============================================================================
-- 6. TABELA DE RESERVAS (Reservations)
-- ============================================================================
CREATE TABLE IF NOT EXISTS reservations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  establishment_id UUID NOT NULL REFERENCES establishments(id) ON DELETE SET NULL,
  reservation_type TEXT NOT NULL CHECK (reservation_type IN ('room', 'table', 'service', 'event')),
  room_id UUID REFERENCES rooms(id) ON DELETE SET NULL,
  check_in_date DATE,
  check_out_date DATE,
  number_of_guests INTEGER,
  table_number TEXT,
  reservation_time TIMESTAMP WITH TIME ZONE,
  party_size INTEGER,
  service_id UUID REFERENCES services(id) ON DELETE SET NULL,
  scheduled_date TIMESTAMP WITH TIME ZONE,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
  notes TEXT,
  total_price DECIMAL(10, 2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_reservations_user_id ON reservations(user_id);
CREATE INDEX idx_reservations_establishment_id ON reservations(establishment_id);
CREATE INDEX idx_reservations_status ON reservations(status);
CREATE INDEX idx_reservations_check_in ON reservations(check_in_date);

-- ============================================================================
-- 7. TABELA DE MENUS/ITENS (Menu Items)
-- ============================================================================
CREATE TABLE IF NOT EXISTS menu_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  establishment_id UUID NOT NULL REFERENCES establishments(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  category TEXT,
  price DECIMAL(10, 2) NOT NULL,
  image_url TEXT,
  is_available BOOLEAN DEFAULT TRUE,
  preparation_time_minutes INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_menu_items_establishment_id ON menu_items(establishment_id);
CREATE INDEX idx_menu_items_category ON menu_items(category);

-- ============================================================================
-- 8. TABELA DE PEDIDOS (Orders)
-- ============================================================================
CREATE TABLE IF NOT EXISTS orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  establishment_id UUID NOT NULL REFERENCES establishments(id) ON DELETE SET NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'preparing', 'ready', 'on_the_way', 'delivered', 'cancelled')),
  order_type TEXT NOT NULL CHECK (order_type IN ('delivery', 'takeaway')),
  total_items INTEGER DEFAULT 0,
  subtotal DECIMAL(10, 2) DEFAULT 0,
  delivery_fee DECIMAL(10, 2) DEFAULT 0,
  tax DECIMAL(10, 2) DEFAULT 0,
  total_price DECIMAL(10, 2) NOT NULL,
  delivery_address TEXT,
  delivery_latitude DECIMAL(10, 8),
  delivery_longitude DECIMAL(11, 8),
  estimated_delivery_time TIMESTAMP WITH TIME ZONE,
  delivered_at TIMESTAMP WITH TIME ZONE,
  special_instructions TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_establishment_id ON orders(establishment_id);
CREATE INDEX idx_orders_status ON orders(status);

-- ============================================================================
-- 9. TABELA DE ITENS DO PEDIDO (Order Items)
-- ============================================================================
CREATE TABLE IF NOT EXISTS order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  menu_item_id UUID NOT NULL REFERENCES menu_items(id) ON DELETE SET NULL,
  item_name TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  unit_price DECIMAL(10, 2) NOT NULL,
  subtotal DECIMAL(10, 2) NOT NULL,
  special_instructions TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- ============================================================================
-- 10. TABELA DE POSTS (Posts)
-- ============================================================================
CREATE TABLE IF NOT EXISTS posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  establishment_id UUID REFERENCES establishments(id) ON DELETE SET NULL,
  content TEXT NOT NULL,
  image_urls TEXT[],
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  shares_count INTEGER DEFAULT 0,
  is_public BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_establishment_id ON posts(establishment_id);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);

ALTER TABLE posts ADD COLUMN search_vector tsvector;
CREATE INDEX idx_posts_search ON posts USING gin(search_vector);

-- ============================================================================
-- 11. TABELA DE COMENTÁRIOS (Comments)
-- ============================================================================
CREATE TABLE IF NOT EXISTS comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  likes_count INTEGER DEFAULT 0,
  parent_comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);

-- ============================================================================
-- 12. TABELA DE LIKES (Likes)
-- ============================================================================
CREATE TABLE IF NOT EXISTS likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
  comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  CONSTRAINT at_least_one_target CHECK (
    (post_id IS NOT NULL AND comment_id IS NULL) OR
    (post_id IS NULL AND comment_id IS NOT NULL)
  ),
  UNIQUE(user_id, post_id),
  UNIQUE(user_id, comment_id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_likes_user_id ON likes(user_id);
CREATE INDEX idx_likes_post_id ON likes(post_id);
CREATE INDEX idx_likes_comment_id ON likes(comment_id);

-- ============================================================================
-- 13. TABELA DE EVENTOS (Events)
-- ============================================================================
CREATE TABLE IF NOT EXISTS events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  establishment_id UUID NOT NULL REFERENCES establishments(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  event_date TIMESTAMP WITH TIME ZONE NOT NULL,
  end_date TIMESTAMP WITH TIME ZONE,
  location TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  ticket_price DECIMAL(10, 2),
  total_tickets INTEGER,
  available_tickets INTEGER,
  image_url TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_events_establishment_id ON events(establishment_id);
CREATE INDEX idx_events_event_date ON events(event_date);

-- ============================================================================
-- 14. TABELA DE INGRESSOS (Tickets)
-- ============================================================================
CREATE TABLE IF NOT EXISTS tickets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  ticket_number TEXT UNIQUE NOT NULL,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'used', 'cancelled')),
  qr_code TEXT,
  purchase_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  used_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_tickets_event_id ON tickets(event_id);
CREATE INDEX idx_tickets_user_id ON tickets(user_id);
CREATE INDEX idx_tickets_status ON tickets(status);

-- ============================================================================
-- 15. TABELA DE AVALIAÇÕES (Reviews)
-- ============================================================================
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  establishment_id UUID NOT NULL REFERENCES establishments(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title TEXT,
  comment TEXT,
  category TEXT,
  helpful_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, establishment_id)
);

CREATE INDEX idx_reviews_establishment_id ON reviews(establishment_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);

-- ============================================================================
-- 16. TABELA DE SEGUINDO (Follows)
-- ============================================================================
CREATE TABLE IF NOT EXISTS follows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT no_self_follow CHECK (follower_id != following_id),
  UNIQUE(follower_id, following_id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_follows_follower_id ON follows(follower_id);
CREATE INDEX idx_follows_following_id ON follows(following_id);

-- ============================================================================
-- 17. TABELA DE NOTIFICAÇÕES (Notifications)
-- ============================================================================
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('reservation', 'order', 'message', 'like', 'comment', 'follow', 'event')),
  title TEXT NOT NULL,
  message TEXT,
  related_id UUID,
  related_type TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);

-- ============================================================================
-- 18. TABELA DE PAGAMENTOS (Payments)
-- ============================================================================
CREATE TABLE IF NOT EXISTS payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  transaction_id TEXT UNIQUE,
  amount DECIMAL(10, 2) NOT NULL,
  currency TEXT DEFAULT 'BRL',
  payment_method TEXT NOT NULL CHECK (payment_method IN ('credit_card', 'debit_card', 'pix', 'wallet')),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'refunded')),
  order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
  reservation_id UUID REFERENCES reservations(id) ON DELETE SET NULL,
  ticket_id UUID REFERENCES tickets(id) ON DELETE SET NULL,
  CONSTRAINT at_least_one_related CHECK (
    (order_id IS NOT NULL) OR
    (reservation_id IS NOT NULL) OR
    (ticket_id IS NOT NULL)
  ),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_order_id ON payments(order_id);

-- ============================================================================
-- RLS (ROW LEVEL SECURITY) - ENABLE
-- ============================================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE establishments ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE room_availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

-- ===== USERS POLICIES =====
CREATE POLICY "Users can read their own data and public profiles"
  ON users FOR SELECT
  USING (auth.uid() = id OR true);

CREATE POLICY "Users can update their own data"
  ON users FOR UPDATE
  USING (auth.uid() = id);

-- ===== ESTABLISHMENTS POLICIES =====
CREATE POLICY "Anyone can view active establishments"
  ON establishments FOR SELECT
  USING (is_active = TRUE);

CREATE POLICY "Partners can update their own establishments"
  ON establishments FOR UPDATE
  USING (auth.uid() = partner_id);

CREATE POLICY "Partners can insert establishments"
  ON establishments FOR INSERT
  WITH CHECK (auth.uid() = partner_id);

-- ===== POSTS POLICIES =====
CREATE POLICY "Anyone can read public posts"
  ON posts FOR SELECT
  USING (is_public = TRUE OR auth.uid() = user_id);

CREATE POLICY "Users can create posts"
  ON posts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own posts"
  ON posts FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own posts"
  ON posts FOR DELETE
  USING (auth.uid() = user_id);

-- ===== COMMENTS POLICIES =====
CREATE POLICY "Anyone can read comments on public posts"
  ON comments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM posts
      WHERE posts.id = comments.post_id
      AND (posts.is_public = TRUE OR posts.user_id = auth.uid())
    )
  );

CREATE POLICY "Users can create comments"
  ON comments FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own comments"
  ON comments FOR UPDATE
  USING (auth.uid() = user_id);

-- ===== LIKES POLICIES =====
CREATE POLICY "Users can like and unlike"
  ON likes FOR ALL
  USING (auth.uid() = user_id);

-- ===== RESERVATIONS POLICIES =====
CREATE POLICY "Users can view their own reservations"
  ON reservations FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Partners can view reservations for their establishments"
  ON reservations FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM establishments
      WHERE establishments.id = reservations.establishment_id
      AND establishments.partner_id = auth.uid()
    )
  );

CREATE POLICY "Users can create reservations"
  ON reservations FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reservations"
  ON reservations FOR UPDATE
  USING (auth.uid() = user_id);

-- ===== ORDERS POLICIES =====
CREATE POLICY "Users can view their own orders"
  ON orders FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Partners can view orders for their establishments"
  ON orders FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM establishments
      WHERE establishments.id = orders.establishment_id
      AND establishments.partner_id = auth.uid()
    )
  );

CREATE POLICY "Users can create orders"
  ON orders FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own orders"
  ON orders FOR UPDATE
  USING (auth.uid() = user_id);

-- ===== NOTIFICATIONS POLICIES =====
CREATE POLICY "Users can view their own notifications"
  ON notifications FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications"
  ON notifications FOR UPDATE
  USING (auth.uid() = user_id);

-- ===== REVIEWS POLICIES =====
CREATE POLICY "Anyone can view reviews"
  ON reviews FOR SELECT
  USING (TRUE);

CREATE POLICY "Users can create reviews"
  ON reviews FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reviews"
  ON reviews FOR UPDATE
  USING (auth.uid() = user_id);

-- ===== FOLLOWS POLICIES =====
CREATE POLICY "Anyone can view follows"
  ON follows FOR SELECT
  USING (TRUE);

CREATE POLICY "Users can follow/unfollow"
  ON follows FOR ALL
  USING (auth.uid() = follower_id);

-- ============================================================================
-- TRIGGERS (Atualizar contadores e timestamps)
-- ============================================================================

CREATE OR REPLACE FUNCTION update_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_users_updated_at();

CREATE OR REPLACE FUNCTION update_posts_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' AND NEW.post_id IS NOT NULL THEN
    UPDATE posts SET likes_count = likes_count + 1 WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' AND OLD.post_id IS NOT NULL THEN
    UPDATE posts SET likes_count = GREATEST(0, likes_count - 1) WHERE id = OLD.post_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER posts_likes_count
  AFTER INSERT OR DELETE ON likes
  FOR EACH ROW
  EXECUTE FUNCTION update_posts_likes_count();

CREATE OR REPLACE FUNCTION update_posts_comments_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE posts SET comments_count = comments_count + 1 WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE posts SET comments_count = GREATEST(0, comments_count - 1) WHERE id = OLD.post_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER posts_comments_count
  AFTER INSERT OR DELETE ON comments
  FOR EACH ROW
  EXECUTE FUNCTION update_posts_comments_count();

CREATE OR REPLACE FUNCTION update_establishment_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE establishments
  SET 
    rating = (
      SELECT AVG(rating)::DECIMAL(3, 2)
      FROM reviews
      WHERE establishment_id = NEW.establishment_id
    ),
    total_reviews = (
      SELECT COUNT(*)
      FROM reviews
      WHERE establishment_id = NEW.establishment_id
    )
  WHERE id = NEW.establishment_id;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER establishment_rating_update
  AFTER INSERT OR UPDATE OR DELETE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_establishment_rating();

CREATE OR REPLACE FUNCTION update_establishments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER establishments_updated_at
  BEFORE UPDATE ON establishments
  FOR EACH ROW
  EXECUTE FUNCTION update_establishments_updated_at();

-- ============================================================================
-- STORED PROCEDURES / FUNÇÕES ÚTEIS
-- ============================================================================

CREATE OR REPLACE FUNCTION nearby_establishments(
  user_lat DECIMAL(10, 8),
  user_lon DECIMAL(11, 8),
  radius_km DECIMAL DEFAULT 5
)
RETURNS TABLE(
  id UUID,
  name TEXT,
  category TEXT,
  distance_km DECIMAL,
  rating DECIMAL(3, 2)
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    e.id,
    e.name,
    e.category,
    (earth_distance(ll_to_earth(user_lat, user_lon), ll_to_earth(e.latitude, e.longitude)) / 1000)::DECIMAL AS distance_km,
    e.rating
  FROM establishments e
  WHERE e.is_active = TRUE
    AND earth_distance(ll_to_earth(user_lat, user_lon), ll_to_earth(e.latitude, e.longitude)) / 1000 <= radius_km
  ORDER BY distance_km ASC;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_room_availability(
  room_id_param UUID,
  check_in DATE,
  check_out DATE
)
RETURNS INTEGER AS $$
DECLARE
  available_count INTEGER;
BEGIN
  SELECT COALESCE(MIN(available_count), 0) INTO available_count
  FROM room_availability
  WHERE room_id = room_id_param
    AND available_date >= check_in
    AND available_date < check_out;
  
  RETURN available_count;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_notification(
  user_id_param UUID,
  type_param TEXT,
  title_param TEXT,
  message_param TEXT DEFAULT NULL,
  related_id_param UUID DEFAULT NULL,
  related_type_param TEXT DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  notification_id UUID;
BEGIN
  INSERT INTO notifications (user_id, type, title, message, related_id, related_type)
  VALUES (user_id_param, type_param, title_param, message_param, related_id_param, related_type_param)
  RETURNING notifications.id INTO notification_id;
  
  RETURN notification_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- INDEXES ADICIONAIS PARA PERFORMANCE
-- ============================================================================

CREATE INDEX idx_reservations_user_establishment ON reservations(user_id, establishment_id);
CREATE INDEX idx_orders_user_establishment ON orders(user_id, establishment_id);
CREATE INDEX idx_posts_user_created ON posts(user_id, created_at DESC);
CREATE INDEX idx_comments_post_created ON comments(post_id, created_at DESC);
CREATE INDEX idx_menu_items_search ON menu_items USING gin(to_tsvector('portuguese', name || ' ' || COALESCE(description, '')));

-- ============================================================================
-- VIEWS ÚTEIS
-- ============================================================================

CREATE OR REPLACE VIEW posts_with_user AS
SELECT 
  p.*,
  u.full_name,
  u.username,
  u.avatar_url,
  (SELECT COUNT(*) FROM likes WHERE post_id = p.id) as actual_likes_count
FROM posts p
JOIN users u ON p.user_id = u.id;

CREATE OR REPLACE VIEW reservations_details AS
SELECT 
  r.*,
  u.full_name as user_name,
  u.email as user_email,
  e.name as establishment_name,
  e.phone as establishment_phone
FROM reservations r
JOIN users u ON r.user_id = u.id
JOIN establishments e ON r.establishment_id = e.id;

CREATE OR REPLACE VIEW orders_details AS
SELECT 
  o.*,
  u.full_name as user_name,
  e.name as establishment_name,
  e.phone as establishment_phone
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN establishments e ON o.establishment_id = e.id;

-- ============================================================================
-- FIM DO SCHEMA - SUCESSO!
-- ============================================================================
