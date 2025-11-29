import 'dart:async';

import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';

class DapurDashboardController extends GetxController {
  final Rx<DateTime> _currentTime = DateTime.now().obs;
  Timer? _ticker;
  final UserController _userController = Get.find<UserController>();
  final Rx<UserDapurAsPIC?> selectedDapur = Rx<UserDapurAsPIC?>(null);

  DateTime get currentTime => _currentTime.value;
  List<UserDapurAsPIC> get dapurOptions =>
      _userController.userModel.value?.dapurAsPIC ?? [];

  @override
  void onInit() {
    super.onInit();
    ever(_userController.userModel, (_) => _ensureSelectedDapur());
    _ensureSelectedDapur();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentTime.value = DateTime.now();
    });
  }

  void _ensureSelectedDapur() {
    final available = dapurOptions;
    if (available.isEmpty) {
      selectedDapur.value = null;
      return;
    }

    final current = selectedDapur.value;
    if (current == null ||
        !available.any((option) => option.id == current.id)) {
      selectedDapur.value = available.first;
    }
  }

  void selectDapurById(String? id) {
    if (id == null) return;
    final available = dapurOptions;
    if (available.isEmpty) {
      selectedDapur.value = null;
      return;
    }

    final match = available.firstWhere(
      (item) => item.id == id,
      orElse: () => available.first,
    );
    selectedDapur.value = match;
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
}
