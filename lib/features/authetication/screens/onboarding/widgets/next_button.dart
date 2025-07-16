import 'package:cinema_app/features/authetication/controllers/onboarding/onboarding_controller.dart';
import 'package:cinema_app/utils/constants/colors.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/device/device_utility.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunctions.isDarkMode(context);
    return Positioned(
      right: MySizes.defaultSpace,
      bottom: MyDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => Get.find<OnBoardingController>().nextPage(),
        style: ElevatedButton.styleFrom(shape: const CircleBorder(), backgroundColor: dark ? MyColors.primary : Colors.black),
        child: const Icon(Iconsax.arrow_right_3),
      )
    );
  }
}



