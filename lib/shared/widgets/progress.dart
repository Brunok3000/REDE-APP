import 'package:flutter/material.dart';

Container circularProgress() {
  return Container(
    padding: const EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    child: const CircularProgressIndicator(
      // Mantemos cor padrão para ícone de loading; poderá ser parametrizado.
      color: Colors.purple,
    ),
  );
}

Container linearProgress() {
  return Container(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: const LinearProgressIndicator(color: Colors.purple),
  );
}
