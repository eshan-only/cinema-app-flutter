
import 'package:cinema_app/features/authetication/controllers/onboarding/onboarding_controller.dart';
import 'package:cinema_app/features/authetication/screens/onboarding/widgets/next_button.dart';
import 'package:cinema_app/features/authetication/screens/onboarding/widgets/onboarding_navg.dart';
import 'package:cinema_app/features/authetication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:cinema_app/features/authetication/screens/onboarding/widgets/skip_button.dart';
import 'package:cinema_app/utils/constants/image_strings.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    
    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scroll
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: MyImgStrings.onBoard01,
                title: MyTexts.onBoardingTitle1,
                subTitle: MyTexts.onBoardingSubTitle1,
                ),
                OnBoardingPage(
                image: MyImgStrings.onBoard02,
                title: MyTexts.onBoardingTitle2,
                subTitle: MyTexts.onBoardingSubTitle2,
                ),
                OnBoardingPage(
                image: MyImgStrings.onBoard03,
                title: MyTexts.onBoardingTitle3,
                subTitle: MyTexts.onBoardingSubTitle3
                ),
            ],
          ),
          // Skip Button
          const OnBoardingSkip(),

          // Dot Navigation
          const OnBoardingDotNavigation(),
          
          // Next button
          const NextButton()
        ],
      ),
    );
  }
}

