import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// Serviço simples para encapsular o uso do ImagePicker.
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Abre a câmera e retorna o arquivo selecionado ou null.
  Future<File?> pickFromCamera({int imageQuality = 85}) async {
    final XFile? xfile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
    return xfile == null ? null : File(xfile.path);
  }

  /// Abre a galeria e retorna o arquivo selecionado ou null.
  Future<File?> pickFromGallery({int imageQuality = 85}) async {
    final XFile? xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
    return xfile == null ? null : File(xfile.path);
  }
}
