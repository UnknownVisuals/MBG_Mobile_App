import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'package:mbg_mobile_app/utils/services/driver_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class DriverDeliveryHistoryController extends GetxController {
  DriverDeliveryHistoryController()
    : _driverService = Get.find<DriverService>();

  final DriverService _driverService;

  final RxList<DriverDeliveryModel> deliveries = <DriverDeliveryModel>[].obs;
  final RxList<DriverDeliveryModel> filteredDeliveries =
      <DriverDeliveryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedStatus = 'ALL'.obs;
  final Rxn<DateTimeRange> selectedDateRange = Rxn<DateTimeRange>();

  final DateFormat _dayFormat = DateFormat('yyyy-MM-dd');

  @override
  void onInit() {
    super.onInit();
    loadDeliveries();
  }

  Future<void> loadDeliveries() async {
    try {
      isLoading.value = true;
      final data = await _driverService.getMyDeliveries();
      deliveries.assignAll(data);
      _applyFilters();
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat riwayat pengiriman: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDeliveries() => loadDeliveries();

  void setStatusFilter(String status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  void setDateRange(DateTimeRange? range) {
    selectedDateRange.value = range;
    _applyFilters();
  }

  void clearDateRange() {
    selectedDateRange.value = null;
    _applyFilters();
  }

  void updateDelivery(DriverDeliveryModel delivery) {
    final index = deliveries.indexWhere((item) => item.id == delivery.id);
    if (index == -1) {
      deliveries.insert(0, delivery);
    } else {
      deliveries[index] = delivery;
    }
    _applyFilters();
  }

  void _applyFilters() {
    Iterable<DriverDeliveryModel> results = deliveries;

    if (selectedStatus.value != 'ALL') {
      results = results.where(
        (delivery) => delivery.status == selectedStatus.value,
      );
    }

    final range = selectedDateRange.value;
    if (range != null) {
      final start = _dayFormat.format(range.start);
      final end = _dayFormat.format(range.end);
      results = results.where((delivery) {
        final created = _dayFormat.format(delivery.createdAt);
        return created.compareTo(start) >= 0 && created.compareTo(end) <= 0;
      });
    }

    final sorted = results.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    filteredDeliveries.assignAll(sorted);
  }
}
