import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mbg_mobile_app/features/authentication/screens/login/login.dart';

class OnBoardingController extends GetxController {
  // Dependencies
  final GetStorage storage = GetStorage();
  final PageController pageController = PageController();

  // State Variables
  RxInt currentPageIndex = 0.obs;

  // Update Current Page Index when Page Scroll
  void updatePageIndicator(index) {
    currentPageIndex.value = index;
  }

  // Jump to Specific Dot Selected Page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //  Update Current Index & Jump to Next Page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      storage.write('hasSeenOnboarding', true);
      Get.to(const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      currentPageIndex.value = page;
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  //  Update Current Index & Jump to Last Page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
