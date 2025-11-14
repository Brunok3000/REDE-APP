class Env {
  // Supabase Configuration - Projeto REDE
  // URL e chaves podem ser carregadas via String.fromEnvironment() ou hardcoded
  // Recomendação: use --dart-define ou .env em desenvolvimento

  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://chyhjtbgzwwdckhptnja.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    // IMPORTANT: do NOT keep a default ANON key here. Set via --dart-define or CI secrets.
    defaultValue: '',
  );
}
