
import 'package:cinema_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cinema_app/features/authetication/screens/password/reset_password.dart';
import 'package:cinema_app/utils/constants/image_strings.dart';
import 'package:cinema_app/utils/helpers/full_screen_loader.dart';
import 'package:cinema_app/utils/helpers/network_manager.dart';
import 'package:cinema_app/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();


  // Send password-reset email
  sendPasswordResetEmail() async{
      try {
        // Start Loading
        MyFullScreenLoader.openLoadingDialog('Processing your request...', MyImgStrings.docerAnimation);

        // Check Internet Connectivity
        final isConnected = await NetworkManager.instance.isConnected();

        if (!isConnected) {
          MyFullScreenLoader.stopLoading();
          return;
        }

        // Form Validation
        if (!forgetPasswordFormKey.currentState!.validate()) {
          MyFullScreenLoader.stopLoading();
          return;
        }

        // Send Email to Reset Password
        await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

        // Remove Loader
        MyFullScreenLoader.stopLoading();

        // Show Success Screen
        MyLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link Sent to Reset your Password'.tr);

        // Redirect
        Get.to(() => ResetPasswordScreen(email: email.text.trim()));
      } catch (e) {
        MyFullScreenLoader.stopLoading();
        MyLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
      }
  }

  // resend password-reset email
  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      MyFullScreenLoader.openLoadingDialog('Processing your request...', MyImgStrings.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
         MyFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // Remove Loader
      MyFullScreenLoader.stopLoading();

      // Show Success Screen
      MyLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link Sent to Reset your Password'.tr);
    } catch (e) {
      // Remove Loader
      MyFullScreenLoader.stopLoading();
      MyLoaders.errorSnackBar(title: "Oh Snap", message: e.toString());
    }
  }


}