import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

void pickSingleImage({required Rx<Uint8List> imageToUpload}) async {
  final image = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      compressionQuality: 1,
      allowedExtensions: ['png', 'jpg', 'jpeg']);

  if(image != null) {
    imageToUpload.value = image.files.first.bytes!;
  }
}