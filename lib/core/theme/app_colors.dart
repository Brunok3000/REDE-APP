import 'package:flutter/material.dart';

/// Paleta de cores da aplicação
/// Tema: Roxo + Branco
class AppColors {
  // Cores Primárias
  static const Color primary = Color(0xFF7C3AED); // Roxo principal
  static const Color primaryLight = Color(0xFFA855F7); // Roxo claro
  static const Color primaryDark = Color(0xFF6D28D9); // Roxo escuro
  static const Color primaryVeryLight = Color(0xFFF3E8FF); // Roxo muito claro

  // Cores Secundárias
  static const Color secondary = Color(0xFFA78BFA); // Roxo secundário
  static const Color secondaryLight = Color(
    0xFFC4B5FD,
  ); // Roxo secundário claro

  // Cores de Superfície
  static const Color surface = Color(0xFFFFFFFF); // Branco puro
  static const Color surfaceVariant = Color(0xFFF8F7FF); // Off-white com roxo
  static const Color background = Color(0xFFF8F7FF); // Background claro

  // Cores de Texto
  static const Color textPrimary = Color(0xFF1F2937); // Cinza escuro
  static const Color textSecondary = Color(0xFF6B7280); // Cinza médio
  static const Color textTertiary = Color(0xFF9CA3AF); // Cinza claro
  static const Color textLight = Color(0xFFD1D5DB); // Cinza muito claro

  // Cores de Status
  static const Color error = Color(0xFFEF4444); // Vermelho
  static const Color errorLight = Color(0xFFFEE2E2); // Vermelho claro
  static const Color success = Color(0xFF10B981); // Verde
  static const Color successLight = Color(0xFFD1FAE5); // Verde claro
  static const Color warning = Color(0xFFF59E0B); // Laranja
  static const Color warningLight = Color(0xFFFEF3C7); // Laranja claro
  static const Color info = Color(0xFF3B82F6); // Azul
  static const Color infoLight = Color(0xFFDEF2F8); // Azul claro

  // Cores de Borda
  static const Color border = Color(0xFFE5E7EB); // Cinza claro
  static const Color borderDark = Color(0xFFD1D5DB); // Cinza médio
  static const Color borderLight = Color(0xFFF3F4F6); // Cinza muito claro

  // Cores Especiais
  static const Color shadow = Color(0x1F000000); // Sombra padrão
  static const Color overlay = Color(0x4D000000); // Overlay escuro
  static const Color divider = Color(0xFFE5E7EB); // Linha divisória

  // Gradientes
  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C3AED), // Roxo
      Color(0xFFA855F7), // Roxo claro
    ],
  );

  static const LinearGradient purpleDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6D28D9), // Roxo escuro
      Color(0xFF7C3AED), // Roxo
    ],
  );

  // Mapa de cores para fácil acesso
  static const Map<String, Color> colorMap = {
    'primary': primary,
    'primaryLight': primaryLight,
    'primaryDark': primaryDark,
    'secondary': secondary,
    'surface': surface,
    'background': background,
    'error': error,
    'success': success,
    'warning': warning,
  };

  /// Retorna um MaterialColor para tema do Material Design
  static MaterialColor get primaryMaterialColor {
    // 'primary.value' pode ser marcado como deprecated em versões recentes do SDK.
    // Usamos o literal da cor base para evitar o uso de propriedade depreciada.
    return MaterialColor(0xFF7C3AED, const {
      50: Color(0xFFF8F5FE),
      100: Color(0xFFF3E8FF),
      200: Color(0xFFE9D5FF),
      300: Color(0xFFD8B4FE),
      400: Color(0xFFC084FC),
      500: primary,
      600: Color(0xFF9333EA),
      700: Color(0xFF7E22CE),
      800: Color(0xFF6D28D9),
      900: primaryDark,
    });
  }

  /// Obtém cor com opacidade
  static Color withOpacity(Color color, double opacity) {
    // Usa withAlpha para evitar APIs obsoletas em alguns contextos.
    final alpha = (opacity * 255).round().clamp(0, 255);
    return color.withAlpha(alpha);
  }

  /// Blend de duas cores
  static Color blend(Color color1, Color color2, double weight) {
    return Color.lerp(color1, color2, weight) ?? color1;
  }
}
