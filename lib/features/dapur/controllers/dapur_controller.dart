import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/timeline_event_data.dart';
import 'package:mbg_mobile_app/features/dapur/screens/widgets/timeline_utils.dart';

class DapurController extends GetxController {
  // Scroll controller for timeline list
  final ScrollController scrollController = ScrollController();

  // Keys for timeline cards
  final List<GlobalKey> cardKeys = [];

  // Observable variables
  final RxList<TimelineEventData> events = <TimelineEventData>[].obs;
  final RxInt completedCount = 0.obs;
  final RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeTimeline();
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
}
