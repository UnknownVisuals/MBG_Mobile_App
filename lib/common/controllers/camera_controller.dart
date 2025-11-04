import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class CameraController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);

  File? get imageFile => selectedImage.value;
  bool get hasImage => selectedImage.value != null;

  void clearImage() {
    selectedImage.value = null;
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
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
  Future<void> captureImageWithCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
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
}
