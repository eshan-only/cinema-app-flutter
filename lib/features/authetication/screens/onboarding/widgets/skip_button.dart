import 'package:cinema_app/features/authetication/controllers/onboarding/onboarding_controller.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MyDeviceUtils.getAppBarHeight(), 
      right: MySizes.defaultSpace, 
      child: TextButton(onPressed: () => Get.find<OnBoardingController>().skipPage(), child: const Text('Skip')),);
  }
}
