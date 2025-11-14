// Edge Function: new_order_notification
// Processa a tabela `order_notifications` (outbox) enviando FCM para o owner do estabelecimento
// Recomendado: agendar essa função para rodar a cada N segundos/minutos ou chamá-la via webhook

import { serve } from 'https://deno.land/std@0.201.0/http/server.ts'

serve(async (req) => {
  try {
    const SUPABASE_URL = Deno.env.get('SUPABASE_URL') || '';
    const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') || Deno.env.get('SUPABASE_SERVICE_ROLE') || '';
    const FCM_SERVER_KEY = Deno.env.get('FCM_SERVER_KEY') || '';

    if (!SUPABASE_URL || !SERVICE_ROLE_KEY || !FCM_SERVER_KEY) {
      return new Response(JSON.stringify({ error: 'Missing env' }), { status: 500 });
    }

    const base = SUPABASE_URL.replace(/\/$/, '') + '/rest/v1';

    // Fetch unsent notifications (cap to 20)
    const outboxUrl = `${base}/order_notifications?sent=eq.false&limit=20&select=*`;
    const outResp = await fetch(outboxUrl, {
      headers: { apikey: SERVICE_ROLE_KEY, authorization: `Bearer ${SERVICE_ROLE_KEY}`, 'Content-Type': 'application/json' },
    });

    if (!outResp.ok) {
      const t = await outResp.text().catch(() => '');
      return new Response(JSON.stringify({ error: 'Failed to fetch outbox', status: outResp.status, body: t }), { status: 502 });
    }

    const notifications = await outResp.json().catch(() => []);
    const results = [];

    for (const n of notifications) {
      try {
        const notifId = n.id;
        const establishmentId = n.establishment_id || (n.payload && n.payload.establishment_id);

        if (!establishmentId) {
          // mark as sent to avoid retry loop
          await fetch(`${base}/order_notifications?id=eq.${encodeURIComponent(String(notifId))}`, {
            method: 'PATCH',
            headers: { apikey: SERVICE_ROLE_KEY, authorization: `Bearer ${SERVICE_ROLE_KEY}`, 'Content-Type': 'application/json' },
            body: JSON.stringify({ sent: true }),
          });
          results.push({ id: notifId, status: 'skipped_no_establishment' });
          continue;
        }

        // Get owner id from establishments
        const estResp = await fetch(`${base}/establishments?id=eq.${encodeURIComponent(String(establishmentId))}&select=id,owner_id`, {
          headers: { apikey: SERVICE_ROLE_KEY, authorization: `Bearer ${SERVICE_ROLE_KEY}` },
        });
        if (!estResp.ok) {
          results.push({ id: notifId, status: 'failed_fetch_establishment', code: estResp.status });
          continue;
        }
        const estJson = await estResp.json().catch(() => []);
        const ownerId = estJson && estJson[0] && estJson[0].owner_id;
        if (!ownerId) { results.push({ id: notifId, status: 'no_owner' }); continue; }

        // Get owner's fcm_token
        const profileResp = await fetch(`${base}/profiles?id=eq.${encodeURIComponent(String(ownerId))}&select=id,fcm_token`, {
          headers: { apikey: SERVICE_ROLE_KEY, authorization: `Bearer ${SERVICE_ROLE_KEY}` },
        });
        if (!profileResp.ok) { results.push({ id: notifId, status: 'failed_fetch_profile', code: profileResp.status }); continue; }
        const profiles = await profileResp.json().catch(() => []);
        const fcmToken = profiles && profiles[0] && profiles[0].fcm_token;
        if (!fcmToken) { results.push({ id: notifId, status: 'no_fcm_token' }); continue; }

        // Prepare and send FCM
        const order = n.payload || {};
        const title = 'Novo pedido';
        const body = order && order.id ? `Novo pedido (${String(order.id).slice(0,8)})` : 'Você tem um novo pedido';

        const fcmResp = await fetch('https://fcm.googleapis.com/fcm/send', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', 'Authorization': `key=${FCM_SERVER_KEY}` },
          body: JSON.stringify({ to: fcmToken, notification: { title, body }, data: { order: JSON.stringify(order) } }),
        });

        const fcmText = await fcmResp.text().catch(() => '');
        let fcmJson = null; try { fcmJson = fcmText ? JSON.parse(fcmText) : null; } catch (_) { fcmJson = { raw: fcmText }; }

        if (!fcmResp.ok) { results.push({ id: notifId, status: 'fcm_failed', code: fcmResp.status, body: fcmJson }); continue; }

        // Mark notification as sent
        const patchResp = await fetch(`${base}/order_notifications?id=eq.${encodeURIComponent(String(notifId))}`, {
          method: 'PATCH',
          headers: { apikey: SERVICE_ROLE_KEY, authorization: `Bearer ${SERVICE_ROLE_KEY}`, 'Content-Type': 'application/json' },
          body: JSON.stringify({ sent: true, sent_at: new Date().toISOString() }),
        });
        if (!patchResp.ok) { results.push({ id: notifId, status: 'sent_but_patch_failed', patchCode: patchResp.status }); continue; }

        results.push({ id: notifId, status: 'sent', fcm: fcmJson });
      } catch (err) {
        results.push({ id: n.id, status: 'error', error: String(err) });
      }
    }

    return new Response(JSON.stringify({ processed: results.length, results }), { status: 200 });
  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({ error: String(err) }), { status: 500 });
  }
});
