import 'package:cinema_app/features/authetication/screens/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  // Variables
  final pageController = PageController();
  final deviceStorage = GetStorage();
  Rx<int> currentPageIndex = 0.obs; // observer widget - will change the design without a stateful widget

  // Update Current Page Index when page scrolls
  void updatePageIndicator(index) {
    currentPageIndex.value = index; 
  }

  // Jump to specific dot selected page
  void dotNavigationClick(index){
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

// Update Current Index and jump to the next page
void nextPage() {
  if (currentPageIndex.value == 2) {
    // If on the last page, navigate to the LoginScreen
    deviceStorage.write('isFirstTime', false);
    Get.offAll(const LoginScreen());
  } else {
    // Increment the currentPageIndex to go to the next page
    currentPageIndex.value += 1; // Move to the next page
    pageController.jumpToPage(currentPageIndex.value);
  }
}


  // Update Current Index and jump to the last page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}