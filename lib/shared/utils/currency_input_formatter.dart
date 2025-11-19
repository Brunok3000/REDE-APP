import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formata a entrada como moeda local simples (ex: 1.234,56)
class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _format = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: '',
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    try {
      String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.isEmpty) return newValue.copyWith(text: '');
      final value = int.parse(digits);
      final doubleValue = value / 100.0;
      final newText = _format.format(doubleValue).trim();
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    } catch (_) {
      return oldValue;
    }
  }
}
