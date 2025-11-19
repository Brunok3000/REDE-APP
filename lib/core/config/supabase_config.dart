// Fonte única de verdade para credenciais Supabase
// Valores extraídos de ../dados_superbase.txt
class SupabaseConfig {
  // URL do projeto Supabase (não mude sem atualizar dados_superbase.txt)
  static const String url = 'https://fgjkuuewrclnxawpovtw.supabase.co';

  // Chave pública anon (usar apenas no cliente)
  // Fonte: dados_superbase.txt
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZnamt1dWV3cmNsbnhhd3BvdnR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzMzE1NjUsImV4cCI6MjA3ODkwNzU2NX0.7lfpII48Q5O45LM0cRssT1RUmpWyb2miw0iKl6EqU0w';

  // Obs: o arquivo `dados_superbase.txt` contém também chaves secretas e senhas
  // (tokens de serviço). Não as espalhe pelo código-fonte público.
}
