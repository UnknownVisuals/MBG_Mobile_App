import 'dart:io';

class MBGFileHelper {
  MBGFileHelper._();

  /// Returns the MIME type for an image file based on its extension.
  /// Defaults to `image/jpeg` when the extension is not recognised.
  static String inferImageContentType(File file) {
    final filename = file.path.split(Platform.pathSeparator).last;
    final extension = filename.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
