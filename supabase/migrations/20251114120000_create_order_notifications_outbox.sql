-- Migration: create order_notifications outbox + trigger
-- Adds an outbox table and a trigger to record new orders for server-side processing

BEGIN;

-- Create outbox table for order notifications
CREATE TABLE IF NOT EXISTS public.order_notifications (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  order_id uuid NOT NULL,
  establishment_id uuid,
  payload jsonb,
  sent boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Index to quickly find unsent notifications
CREATE INDEX IF NOT EXISTS idx_order_notifications_sent_created_at
  ON public.order_notifications (sent, created_at);

-- Trigger function: after insert on orders, insert a row in order_notifications
CREATE OR REPLACE FUNCTION public.enqueue_order_notification()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  -- Insert minimal payload; Edge Function can fetch full order details if needed
  INSERT INTO public.order_notifications(order_id, establishment_id, payload, sent, created_at)
  VALUES (NEW.id, NEW.establishment_id, to_jsonb(NEW), false, now());
  RETURN NEW;
END;
$$;

-- Drop existing trigger if exists, then create
DROP TRIGGER IF EXISTS trg_orders_enqueue_notification ON public.orders;
CREATE TRIGGER trg_orders_enqueue_notification
AFTER INSERT ON public.orders
FOR EACH ROW
EXECUTE FUNCTION public.enqueue_order_notification();

COMMIT;
