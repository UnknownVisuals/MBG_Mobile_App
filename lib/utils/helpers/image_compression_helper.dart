import 'dart:io';

import 'package:image/image.dart' as img;

// Keep a safe margin below server payload limits to account for multipart
// headers/boundaries and avoid 413 responses.
const int kSafeUploadImageBytes = 1 * 1024 * 1024;

Future<void> ensureImageFileWithinMaxSize(
  File sourceFile, {
  int maxBytes = kSafeUploadImageBytes,
}) async {
  final fileBytes = await sourceFile.length();
  if (fileBytes > maxBytes) {
    throw Exception('Ukuran foto melebihi batas aman 1 MB');
  }
}

Future<File> compressImageFileToMaxSize(
  File sourceFile, {
  int maxBytes = kSafeUploadImageBytes,
}) async {
  final originalBytes = await sourceFile.readAsBytes();
  if (originalBytes.length <= maxBytes) {
    return sourceFile;
  }

  final decodedImage = img.decodeImage(originalBytes);
  if (decodedImage == null) {
    throw Exception('Gambar tidak dapat diproses untuk kompresi');
  }

  final compressedDir = sourceFile.parent;
  final fileName = sourceFile.path.split(Platform.pathSeparator).last;
  final dotIndex = fileName.lastIndexOf('.');
  final fileStem = dotIndex == -1 ? fileName : fileName.substring(0, dotIndex);

  final dimensionCandidates = <int>[
    4096,
    3072,
    2560,
    2048,
    1600,
    1280,
    1024,
    800,
    640,
    480,
  ];
  final qualityCandidates = <int>[
    90,
    85,
    80,
    75,
    70,
    65,
    60,
    55,
    50,
    45,
    40,
    35,
    30,
    25,
  ];

  for (final maxDimension in dimensionCandidates) {
    final resizedImage = _resizeToFit(decodedImage, maxDimension);

    for (final quality in qualityCandidates) {
      final encodedBytes = img.encodeJpg(resizedImage, quality: quality);
      if (encodedBytes.length <= maxBytes) {
        final compressedFile = File(
          '${compressedDir.path}${Platform.pathSeparator}${fileStem}_compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await compressedFile.writeAsBytes(encodedBytes, flush: true);
        return compressedFile;
      }
    }
  }

  throw Exception('Gambar tetap melebihi batas aman 1 MB setelah dikompresi');
}

img.Image _resizeToFit(img.Image image, int maxDimension) {
  final longestEdge = image.width > image.height ? image.width : image.height;
  if (longestEdge <= maxDimension) {
    return image;
  }

  if (image.width >= image.height) {
    return img.copyResize(image, width: maxDimension);
  }

  return img.copyResize(image, height: maxDimension);
}
