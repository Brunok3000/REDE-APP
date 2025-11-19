import 'dart:developer' as developer;

class LoggerService {
  final String tag;

  LoggerService([this.tag = 'APP']);

  void log(String message, [Map<String, Object?>? data]) {
    developer.log(message, name: tag, error: data);
  }

  void info(String message) => log('[INFO] $message');
  void warn(String message) => log('[WARN] $message');
  void error(String message, [Object? error]) =>
      developer.log('[ERROR] $message', name: tag, error: error);
}
