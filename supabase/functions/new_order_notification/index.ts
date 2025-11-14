// Edge Function: new_order_notification
// Recebe um payload com order, busca o partner (owner) e envia FCM usando a SERVICE_ROLE_KEY para acessar o perfil

// Use explicit std URL to ensure bundler resolves the module correctly
import { serve } from 'https://deno.land/std@0.201.0/http/server.ts'

serve(async (req) => {
  try {
    const body = await req.json().catch(() => ({}));
    const order = (body && body.order) ? body.order : (Object.keys(body).length ? body : null);

    if (!order || !order.establishment_id) {
      return new Response(JSON.stringify({ error: 'Invalid payload: missing order or establishment_id' }), { status: 400 });
    }

    // Obtenha variáveis de ambiente
    const SUPABASE_URL = Deno.env.get('SUPABASE_URL') || '';
    const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') || Deno.env.get('SUPABASE_SERVICE_ROLE') || '';
    const FCM_SERVER_KEY = Deno.env.get('FCM_SERVER_KEY') || '';

    if (!SUPABASE_URL || !SERVICE_ROLE_KEY || !FCM_SERVER_KEY) {
      return new Response('Missing env', { status: 500 });
    }

    // Busca estabelecimento para obter owner_id
    const estabId = order.establishment_id;
    const supabaseProfileUrl = `${SUPABASE_URL.replace(/\/$/, '')}/rest/v1/profiles`;

    // Busca owner do estabelecimento
    const estResp = await fetch(`${SUPABASE_URL.replace(/\/$/, '')}/rest/v1/establishments?id=eq.${encodeURIComponent(String(estabId))}&select=id,owner_id`, {
      headers: {
        apikey: SERVICE_ROLE_KEY,
        authorization: `Bearer ${SERVICE_ROLE_KEY}`,
        'Content-Type': 'application/json'
      }
    });
    if (!estResp.ok) {
      const t = await estResp.text().catch(() => '');
      return new Response(JSON.stringify({ error: 'Failed to fetch establishment', status: estResp.status, body: t }), { status: 502 });
    }
    const estJson = await estResp.json().catch(() => []);
    const ownerId = estJson && estJson[0] && estJson[0].owner_id;

    if (!ownerId) return new Response('Owner not found', { status: 404 });

    // Busca FCM token do owner
    const profileResp = await fetch(`${supabaseProfileUrl}?id=eq.${encodeURIComponent(String(ownerId))}&select=id,fcm_token`, {
      headers: {
        apikey: SERVICE_ROLE_KEY,
        authorization: `Bearer ${SERVICE_ROLE_KEY}`
      }
    });
    if (!profileResp.ok) {
      const t = await profileResp.text().catch(() => '');
      return new Response(JSON.stringify({ error: 'Failed to fetch profile', status: profileResp.status, body: t }), { status: 502 });
    }
    const profiles = await profileResp.json().catch(() => []);
    const fcmToken = profiles && profiles[0] && profiles[0].fcm_token;

    if (!fcmToken) return new Response('No FCM token for owner', { status: 404 });

    // Envia push via FCM
    const fcmResp = await fetch('https://fcm.googleapis.com/fcm/send', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `key=${FCM_SERVER_KEY}`
      },
      body: JSON.stringify({
        to: fcmToken,
        notification: {
          title: 'Novo pedido',
          body: `Você tem um novo pedido (${order.id})`,
        },
        data: { order: JSON.stringify(order) }
      })
    });
    const fcmText = await fcmResp.text().catch(() => '');
    let fcmJson = null;
    try { fcmJson = fcmText ? JSON.parse(fcmText) : null; } catch (_) { fcmJson = { raw: fcmText }; }

    if (!fcmResp.ok) {
      return new Response(JSON.stringify({ error: 'FCM send failed', status: fcmResp.status, body: fcmJson }), { status: 502 });
    }

    return new Response(JSON.stringify({ ok: true, fcm: fcmJson }), { status: 200 });
  } catch (err) {
    console.error(err);
    return new Response('Internal error', { status: 500 });
  }
});
