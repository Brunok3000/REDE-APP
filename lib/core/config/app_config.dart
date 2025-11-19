// Configurações globais do app (modo demo, uso de Supabase)
class AppConfig {
  // Quando true, inicializa Supabase; quando false, usa apenas os repositórios mock.
  static const bool useSupabase = false;

  // Modo demo: ao ativar, o app irá seedar dados fictícios e abrir a rota inicial '/' para demonstração
  static const bool demoMode = true;
}
