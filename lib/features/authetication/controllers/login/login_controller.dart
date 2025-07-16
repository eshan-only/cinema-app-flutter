import 'package:cinema_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cinema_app/features/personalization/controllers/user_controller.dart';
import 'package:cinema_app/utils/constants/image_strings.dart';
import 'package:cinema_app/utils/helpers/full_screen_loader.dart';
import 'package:cinema_app/utils/helpers/network_manager.dart';
import 'package:cinema_app/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final userController = Get.put(UserController());
  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
  }

  void emailAndPasswordLogin() async {
    try {
      MyFullScreenLoader.openLoadingDialog("Logging you in...", MyImgStrings.docerAnimation);

      if (!await _isConnected()) return;

      if (!loginFormKey.currentState!.validate()) {
        MyFullScreenLoader.stopLoading();
        return;
      }

      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());
      MyFullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      MyFullScreenLoader.stopLoading();
      _showErrorSnackBar('Oh Snap!', e.toString());
    }
  }

  Future<void> googleSignIn() async {
    try {
      MyFullScreenLoader.openLoadingDialog('Logging you in...', MyImgStrings.docerAnimation);

      if (!await _isConnected()) return;

      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      if (userCredentials?.user == null) {
        throw Exception('Google sign-in failed. No user data found.');
      }

      final userExists = await userController.checkUserRecordExists(userCredentials?.user!.uid);

      if (!userExists) {
        await userController.saveUserRecord(userCredentials);
      }

      MyFullScreenLoader.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      MyFullScreenLoader.stopLoading();
      _showErrorSnackBar("Oh Snap", e.toString());
    }
  }

  Future<bool> _isConnected() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      MyFullScreenLoader.stopLoading();
      _showErrorSnackBar("Network Error", "Please check your internet connection.");
    }
    return isConnected;
  }

  void _showErrorSnackBar(String title, String message) {
    MyLoaders.errorSnackBar(title: title, message: message);
  }
}
