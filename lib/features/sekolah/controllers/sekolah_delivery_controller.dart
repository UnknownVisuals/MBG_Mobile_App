import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_delivery_model.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';

class SekolahDeliveryController extends GetxController {
  SekolahDeliveryController({SekolahService? sekolahService})
    : _sekolahService = sekolahService ?? Get.find<SekolahService>();

  final SekolahService _sekolahService;
  final UserController _userController = Get.find<UserController>();

  final RxList<SekolahDeliveryModel> deliveries = <SekolahDeliveryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString selectedFilter = 'all'.obs;

  String? get sekolahId =>
      _userController.userModel.value?.sekolahAsPIC.first.id;

  String get sekolahName =>
      _userController.userModel.value?.sekolahAsPIC.first.nama ?? 'Sekolah';

  @override
  void onInit() {
    super.onInit();
    ever(_userController.userModel, (_) => _fetchIfPossible());
  }

  @override
  void onReady() {
    super.onReady();
    _fetchIfPossible();
  }

  void _fetchIfPossible() {
    final id = sekolahId;
    if (id != null && id.isNotEmpty) {
      fetchDeliveries();
    }
  }

  List<SekolahDeliveryModel> get filteredDeliveries {
    final List<SekolahDeliveryModel> list = deliveries.toList();
    switch (selectedFilter.value) {
      case 'pending':
        return list
            .where(
              (item) => item.normalizedStatus == SekolahDeliveryStatus.pending,
            )
            .toList();
      case 'in_transit':
        return list
            .where(
              (item) =>
                  item.normalizedStatus == SekolahDeliveryStatus.inTransit,
            )
            .toList();
      case 'completed':
        return list
            .where(
              (item) =>
                  item.normalizedStatus == SekolahDeliveryStatus.completed,
            )
            .toList();
      default:
        return list;
    }
  }

  int get totalCount => deliveries.length;
  int get pendingCount => deliveries
      .where((item) => item.normalizedStatus == SekolahDeliveryStatus.pending)
      .length;
  int get inTransitCount => deliveries
      .where((item) => item.normalizedStatus == SekolahDeliveryStatus.inTransit)
      .length;
  int get completedCount => deliveries
      .where((item) => item.normalizedStatus == SekolahDeliveryStatus.completed)
      .length;

  void setFilter(String filter) => selectedFilter.value = filter;

  Future<void> fetchDeliveries() async {
    final currentId = sekolahId;
    if (currentId == null || currentId.isEmpty) {
      deliveries.clear();
      return;
    }
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final results = await _sekolahService.getPengirimanBySekolah(currentId);
      deliveries.assignAll(results);
    } catch (error) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat pengiriman',
        message: error.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDeliveries() async => fetchDeliveries();

  Future<void> handleScannedSekolahQrCode(String qrCodeId) async {
    final normalized = qrCodeId.trim();
    if (normalized.isEmpty) return;
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      final updatedDelivery = await _sekolahService.scanSekolahQR(normalized);
      _updateOrInsertDelivery(updatedDelivery);
      MBGLoaders.successSnackBar(
        title: 'Pengiriman selesai',
        message: 'Status pengiriman ${updatedDelivery.qrCodeId} diperbarui.',
      );
    } catch (error) {
      MBGLoaders.errorSnackBar(title: 'Scan Gagal', message: error.toString());
      rethrow;
    } finally {
      isSubmitting.value = false;
    }
  }

  void _updateOrInsertDelivery(SekolahDeliveryModel delivery) {
    final index = deliveries.indexWhere((item) => item.id == delivery.id);
    if (index >= 0) {
      deliveries[index] = delivery;
    } else {
      deliveries.insert(0, delivery);
    }
    deliveries.refresh();
  }
}
