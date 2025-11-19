String? requiredValidator(
  String? value, {
  String message = 'Campo obrigatório',
}) {
  if (value == null || value.trim().isEmpty) return message;
  return null;
}

String? emailValidator(String? value, {String message = 'Email inválido'}) {
  if (value == null || value.trim().isEmpty) return message;
  // Regex corrigida para validar e-mails (usa raw string com escapes corretos)
  final pattern = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!pattern.hasMatch(value.trim())) return message;
  return null;
}

String? passwordValidator(String? value, {int minLength = 6, String? message}) {
  if (value == null || value.isEmpty) {
    return message ?? 'Senha inválida';
  }
  if (value.length < minLength) {
    return message ?? 'Senha deve ter ao menos $minLength caracteres';
  }
  return null;
}
