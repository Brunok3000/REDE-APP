import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Pequeno wrapper para upload de arquivos ao Supabase Storage.
/// Não lê credenciais daqui — use o Supabase inicializado em `main.dart` com `SupabaseConfig`.
class FileUploadService {
  final SupabaseClient client;

  FileUploadService({required this.client});

  /// Faz upload de um arquivo para um bucket e caminho fornecidos.
  /// Retorna a publicUrl gerada ou null em caso de erro.
  Future<String?> uploadFile({
    required File file,
    required String bucket,
    required String path,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      await client.storage
          .from(bucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(cacheControl: '3600'),
          );
      // getPublicUrl pode retornar diferentes shapes dependendo da versão; usar toString() como fallback seguro
      final publicUrlObj = client.storage.from(bucket).getPublicUrl(path);
      return publicUrlObj.toString();
    } catch (_) {
      return null;
    }
  }
}
