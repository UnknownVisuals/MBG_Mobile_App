import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';

class DapurController extends GetxController {
  DapurController() : _userController = Get.put(UserController());

  final UserController _userController;

  /// Drawer navigation index shared across Dapur screens.
  final RxInt drawerSelectedIndex = 0.obs;

  /// Loading indicator while resolving assigned dapur list.
  final RxBool isDapurLoading = false.obs;

  /// Dapur locations assigned to the authenticated user.
  final RxList<AssignedDapur> assignedDapur = <AssignedDapur>[].obs;

  /// Currently selected dapur context.
  final Rxn<AssignedDapur> selectedDapur = Rxn<AssignedDapur>();

  @override
  void onInit() {
    super.onInit();
    loadAssignedDapur();
  }

  /// Navigate between drawer sections.
  void updateSelectedIndex(int index) {
    drawerSelectedIndex.value = index;
  }

  /// Fetch and cache dapur assignments from the authenticated profile.
  Future<void> loadAssignedDapur({bool forceRefresh = false}) async {
    if (assignedDapur.isNotEmpty && !forceRefresh) {
      return;
    }

    try {
      isDapurLoading.value = true;

      if (_userController.userModel.value == null || forceRefresh) {
        await _userController.fetchUserProfile();
      }

      final List<AssignedDapur> dapurList =
          _userController.userModel.value?.dapurAsPIC ?? const [];

      assignedDapur.assignAll(dapurList);

      if (assignedDapur.isEmpty) {
        selectedDapur.value = null;
        return;
      }

      final currentId = selectedDapur.value?.id;
      final existing = _findAssignedDapurById(currentId);

      selectedDapur.value = existing ?? assignedDapur.first;
    } finally {
      isDapurLoading.value = false;
    }
  }

  /// Change selected dapur by identifier.
  void selectDapur(String dapurId) {
    final next = _findAssignedDapurById(dapurId);
    if (next != null) {
      selectedDapur.value = next;
    }
  }

  AssignedDapur? _findAssignedDapurById(String? dapurId) {
    if (dapurId == null) return null;
    for (final item in assignedDapur) {
      if (item.id == dapurId) return item;
    }
    return null;
  }
}
