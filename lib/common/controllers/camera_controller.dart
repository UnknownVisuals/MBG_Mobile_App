import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

class CameraController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);

  File? get imageFile => selectedImage.value;
  bool get hasImage => selectedImage.value != null;

  void clearImage() {
    selectedImage.value = null;
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery({bool addWatermark = false}) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        if (addWatermark) {
          file = await _addWatermark(file);
        }
        selectedImage.value = file;
      } else {
        MBGLoaders.errorSnackBar(
          title: 'Gagal Memilih Gambar',
          message: 'Tidak ada gambar yang dipilih',
        );
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Memilih Gambar',
        message: e.toString(),
      );
    }
  }

  // Capture image using camera
  Future<void> captureImageWithCamera({bool addWatermark = false}) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        if (addWatermark) {
          file = await _addWatermark(file);
        }
        selectedImage.value = file;
      } else {
        MBGLoaders.errorSnackBar(
          title: 'Gagal Mengambil Foto',
          message: 'Tidak ada foto yang diambil',
        );
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Mengambil Foto',
        message: e.toString(),
      );
    }
  }

  // Add watermark to image
  Future<File> _addWatermark(File file) async {
    try {
      final imageBytes = await file.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image != null) {
        final now = DateTime.now();
        final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
        final String text = formattedDate;

        // Simple Text Watermark (No Scaling)
        // Use the largest built-in font
        final font = img.arial48;

        // Calculate position (Bottom Center)
        // Note: arial48 is roughly 24x48 pixels per character, but variable.
        // We can estimate width or just center based on image width.
        // A simple estimation for centering:
        final int estimatedTextWidth = text.length * 24;
        final int x = (image.width - estimatedTextWidth) ~/ 2;
        final int y = image.height - 200;

        img.drawString(
          image,
          text,
          font: font,
          x: x,
          y: y,
          color: img.ColorRgba8(255, 63, 63, 255),
        );

        final watermarkedBytes = img.encodeJpg(image);
        await file.writeAsBytes(watermarkedBytes);
      }
      return file;
    } catch (e) {
      return file;
    }
  }
}
