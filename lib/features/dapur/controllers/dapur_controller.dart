import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/timeline_event_data.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/timeline_utils.dart';
import 'package:mbg_mobile_app/utils/http/dapur_service.dart';

class DapurController extends GetxController {
  DapurController()
    : _dapurService = Get.find<DapurService>(),
      _userController = Get.find<UserController>();

  final DapurService _dapurService;
  final UserController _userController;

  // Scroll controller for timeline list
  final ScrollController scrollController = ScrollController();

  // Keys for timeline cards
  final List<GlobalKey> cardKeys = [];

  // Observable variables
  final RxList<TimelineEventData> events = <TimelineEventData>[].obs;
  final RxInt completedCount = 0.obs;
  final RxInt totalCount = 0.obs;

  // Drawer navigation index
  final RxInt drawerSelectedIndex = 0.obs;

  // Dapur assignments
  final RxList<DapurModel> assignedDapur = <DapurModel>[].obs;
  final Rxn<DapurModel> selectedDapur = Rxn<DapurModel>();
  final RxBool isDapurLoading = false.obs;
  final Rxn<String> dapurError = Rxn<String>();

  bool _hasFetchedDapur = false;

  @override
  void onInit() {
    super.onInit();
    _initializeTimeline();
    loadAssignedDapur();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Initialize timeline data and card keys
  void _initializeTimeline() {
    // Get sample events
    events.value = TimelineUtils.getSampleEvents();

    // Create keys for each card
    for (int i = 0; i < events.length; i++) {
      cardKeys.add(GlobalKey());
    }

    // Calculate counts
    _updateCounts();

    // Scroll to active card after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToActiveCard();
    });
  }

  /// Update completed and total counts
  void _updateCounts() {
    completedCount.value = events.where((e) => e.isCompleted).length;
    totalCount.value = events.length;
  }

  /// Scroll to the active card in the timeline
  void scrollToActiveCard() {
    final activeIndex = events.indexWhere((event) => event.isActive);

    if (activeIndex == -1) return;
    if (cardKeys[activeIndex].currentContext == null) return;

    final RenderBox? renderBox =
        cardKeys[activeIndex].currentContext!.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final BuildContext? context = cardKeys[activeIndex].currentContext;
    if (context == null) return;

    final offset = renderBox.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = renderBox.size.height;

    final targetScroll =
        scrollController.offset +
        offset -
        (screenHeight / 2) +
        (cardHeight / 2);

    scrollController.animateTo(
      targetScroll.clamp(0.0, scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// Refresh timeline data
  void refreshTimeline() {
    events.value = TimelineUtils.getSampleEvents();
    _updateCounts();
  }

  /// Load dapur data assigned to the current user.
  Future<void> loadAssignedDapur({bool forceRefresh = false}) async {
    if (isDapurLoading.value) return;
    if (_hasFetchedDapur && !forceRefresh) return;

    final user = _userController.user.value;
    if (user == null) {
      assignedDapur.clear();
      selectedDapur.value = null;
      return;
    }

    isDapurLoading.value = true;
    dapurError.value = null;

    final previousSelectedId = selectedDapur.value?.id;

    try {
      final assignments = user.dapurAsPIC;
      List<DapurModel> fetchedDapur = [];

      if (assignments.isNotEmpty) {
        fetchedDapur = await Future.wait(
          assignments.map(
            (assigned) => _dapurService.getDapurById(assigned.id),
          ),
        );
      } else if (user.role == 'SUPERADMIN' || user.role == 'ADMIN') {
        fetchedDapur = await _dapurService.getAllDapur();
      }

      assignedDapur.assignAll(fetchedDapur);

      if (assignedDapur.isEmpty) {
        selectedDapur.value = null;
      } else if (previousSelectedId != null) {
        DapurModel? retained;
        for (final dapur in assignedDapur) {
          if (dapur.id == previousSelectedId) {
            retained = dapur;
            break;
          }
        }
        selectedDapur.value = retained ?? assignedDapur.first;
      } else {
        selectedDapur.value = assignedDapur.first;
      }
    } catch (e) {
      assignedDapur.clear();
      selectedDapur.value = null;
      dapurError.value = e.toString();
    } finally {
      isDapurLoading.value = false;
      _hasFetchedDapur = true;
    }
  }

  /// Select a dapur by id.
  void selectDapur(String dapurId) {
    for (final dapur in assignedDapur) {
      if (dapur.id == dapurId) {
        selectedDapur.value = dapur;
        return;
      }
    }
  }
}
