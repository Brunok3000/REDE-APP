import 'package:flutter/material.dart';

class DialogHelper {
  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    String? message,
    String okLabel = 'OK',
    String cancelLabel = 'Cancelar',
  }) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: message == null ? null : Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelLabel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(okLabel),
              ),
            ],
          ),
    );
  }

  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    String? message,
    String okLabel = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: message == null ? null : Text(message),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(okLabel),
              ),
            ],
          ),
    );
  }
}
