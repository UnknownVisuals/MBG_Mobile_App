import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_pengiriman_model.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class SekolahDeliveryHistoryController extends GetxController {
  SekolahDeliveryHistoryController()
    : _sekolahService = Get.find<SekolahService>(),
      _userController = Get.find<UserController>();

  final SekolahService _sekolahService;
  final UserController _userController;

  final RxList<SekolahPengirimanModel> deliveries =
      <SekolahPengirimanModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString filterStatus = 'ALL'.obs;

  List<SekolahPengirimanModel> get filteredDeliveries {
    if (filterStatus.value == 'ALL') return deliveries;
    return deliveries
        .where((delivery) => delivery.status == filterStatus.value)
        .toList();
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '$hours jam $minutes menit';
    }
    return '${duration.inMinutes} menit';
  }

  Color statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'DIAMBIL':
        return Colors.blue;
      case 'DITERIMA':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return Icons.pending_actions;
      case 'DIAMBIL':
        return Icons.local_shipping;
      case 'DITERIMA':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  String deliveryDuration(DateTime start, DateTime end) {
    return _formatDuration(end.difference(start));
  }

  Future<void> loadDeliveries() async {
    final sekolahId = _sekolahId;
    if (sekolahId == null) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Anda tidak memiliki akses ke sekolah',
      );
      return;
    }

    try {
      isLoading.value = true;
      final result = await _sekolahService.getPengirimanBySekolah(sekolahId);
      deliveries.assignAll(result);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat riwayat pengiriman: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await loadDeliveries();
  }

  void setFilter(String status) {
    filterStatus.value = status;
  }

  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '-';
    return DateFormat('dd MMM yyyy HH:mm').format(timestamp);
  }

  String? get _sekolahId {
    final sekolahAsPic = _userController.userModel.value?.sekolahAsPIC;
    if (sekolahAsPic == null || sekolahAsPic.isEmpty) return null;
    return sekolahAsPic.first.id;
  }

  @override
  void onInit() {
    super.onInit();
    loadDeliveries();
  }
}
