import 'package:cinema_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cinema_app/data/repositories/user_repository.dart';
import 'package:cinema_app/features/authetication/screens/signup/widgets/verify_email.dart';
import 'package:cinema_app/features/personalization/models/user_model.dart';
import 'package:cinema_app/utils/constants/image_strings.dart';
import 'package:cinema_app/utils/helpers/network_manager.dart';
import 'package:cinema_app/utils/popups/full_screen_loader.dart';
import 'package:cinema_app/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();
  
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final firstName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void signup() async{
    try{
      // Start Loading
      MyFullScreenLoader.openLoadingDialog("We are processing your information...", MyImgStrings.docerAnimation);
      
      // Check Network
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) {
        MyFullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if(!signupFormKey.currentState!.validate()) {
        MyFullScreenLoader.stopLoading();
        return;
      }
      // Check Privacy Policy
      if(!privacyPolicy.value){
        MyLoaders.warningSnackBar(
          title: 'Accept Privacy Policy', 
          message: 'In order to create an account, you must accept our Privacy Policy & Terms of Use.',
        );
        return;
      }

      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());
      final newUser = UserModel(id: userCredential.user!.uid, firstName: firstName.text.trim(), lastName: lastName.text.trim(), username: username.text.trim(), email: email.text.trim(), phoneNumber: phoneNumber.text.trim(), profilePicture: '', role: 'User', favourite_movies: [], );
      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);
      
      MyFullScreenLoader.stopLoading();
      // Success Message
      MyLoaders.successSnackBar(title: 'Congratulations!', message: "Your account has been created! Verify email to continue.");
      Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
    } catch(e) {
      
      MyFullScreenLoader.stopLoading();
      // Show some generic error 
      MyLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}