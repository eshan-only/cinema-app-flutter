import 'dart:async';

import 'package:cinema_app/common/widgets/success_screen/success_screen.dart';
import 'package:cinema_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cinema_app/utils/constants/image_strings.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:cinema_app/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  /// Send Email Whenever Verify Screen appears & Set Timer for auto redirect.
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  /// Send Email Verification Link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      MyLoaders.successSnackBar(
          title: "Email Sent", message: "Please Check your inbox and verify your email.");
    } catch (e) {
      MyLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  /// Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();

        final user = FirebaseAuth.instance.currentUser;
        if (user?.emailVerified ?? false) {
          timer.cancel();
          Get.off(
            () => SuccessScreen(
              image: MyImgStrings.success,
              title: MyTexts.yourAccountCreatedTitle,
              subTitle: MyTexts.yourAccountCreatedSubTitle,
              onPressed: () => AuthenticationRepository.instance.screenRedirect(),
            ), 
          );
        }
      },
    );
  }

  /// Manually Check if Email verified
  checkEmailVerificationStatus() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null && currentUser.emailVerified) {
    Get.off(
      () => SuccessScreen(
        image: MyImgStrings.success,
        title: MyTexts.yourAccountCreatedTitle,
        subTitle: MyTexts.yourAccountCreatedSubTitle,
        onPressed: () => AuthenticationRepository.instance.screenRedirect(),
      ),
    );
  }
}
}