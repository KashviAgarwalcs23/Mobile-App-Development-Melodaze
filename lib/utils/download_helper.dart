import 'dart:io';
import 'package:flutter/services.dart';
import 'package:file_saver/file_saver.dart';

Future<bool> downloadAssetToDownloads(String assetPath, String fileName) async {
  try {
    // Load asset as bytes
    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List();

    final res = await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      ext: 'mp3',
      mimeType: MimeType.mp3,
    );
    return res != null;
  } catch (e) {
    print('Download error: $e');
    return false;
  }
}
