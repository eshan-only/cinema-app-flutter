import 'package:cinema_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cinema_app/data/repositories/user_repository.dart';
import 'package:cinema_app/features/authetication/screens/login/login.dart';
import 'package:cinema_app/features/personalization/screens/profile/widgets/reauthenticate_user_login.dart';
import 'package:cinema_app/utils/constants/image_strings.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/helpers/full_screen_loader.dart';
import 'package:cinema_app/utils/helpers/network_manager.dart';
import 'package:cinema_app/utils/popups/loaders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());
  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit(){
      super.onInit();
      fetchUserRecord();
  }

  // Fetch User Record
  Future<void> fetchUserRecord() async{
    try{
      final user = await userRepository.fetchUserRecord();
      this.user(user);
    } catch(e){
      user(UserModel.empty()); 
    }
  }

  Future<bool> checkUserRecordExists(String? uid) async {
  try {
    final userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return userDoc.exists;
  } catch (e) {
    MyLoaders.errorSnackBar(title: 'Error', message: 'Failed to check user record: $e');
    return false;
  }
}
  /// Save user Record from any Registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      if (userCredentials != null) {
        // Convert Name to First and Last Name
        final nameParts = UserModel.nameParts(userCredentials.user!.displayName ?? '');
        final username = UserModel.generateUsername(userCredentials.user!.displayName ?? '');

        // Map Data
        final user = UserModel(
          id: userCredentials.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          username: username,
          email: userCredentials.user!.email ?? '',
          phoneNumber: userCredentials.user!.phoneNumber ?? '',
          profilePicture: userCredentials.user!.photoURL ?? '',
          role: 'User', favourite_movies: []
        );

        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      MyLoaders.errorSnackBar(title: "Data not saved!", message: 'Something went wrong saving your information. You can re-save it on your profile.');
    }
  }
  /// Warning Popup - Logout / Delete
 void showConfirmationPopup({
  required String title,
  required String message,
  required String confirmButtonText,
  required VoidCallback onConfirm,
}) {
  Get.defaultDialog(
    contentPadding: const EdgeInsets.all(MySizes.md),
    title: title,
    middleText: message,
    confirm: ElevatedButton(
      onPressed: onConfirm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: MySizes.lg),
        child: Text(confirmButtonText),
      ),
    ),
    cancel: OutlinedButton(
      child: const Text('Cancel'),
      onPressed: () => Navigator.of(Get.overlayContext!).pop(),
    ),
  );
}


  /// Delete User Account
  void deleteUserAccount() async {
    try {
      MyFullScreenLoader.openLoadingDialog('Processing', MyImgStrings.docerAnimation);

      // First re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider = auth.authUser!.providerData.map((e) => e.providerId).first;

      // Re-verify Auth Email
      if (provider == 'google.com') {
        await auth.signInWithGoogle();
        await auth.deleteAccount();

        MyFullScreenLoader.stopLoading();
        Get.offAll(() => const LoginScreen());
      } else if (provider == 'password') {
        MyFullScreenLoader.stopLoading();
        Get.to(() => const ReAuthLoginForm());
      }
    } catch (e) {
      MyFullScreenLoader.stopLoading();
      MyLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
    /// RE-AUTHENTICATE before deleting
Future<void> reAuthenticateEmailAndPasswordUser() async {
  try {
    MyFullScreenLoader.openLoadingDialog('Processing', MyImgStrings.docerAnimation);

    // Check Internet
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      MyFullScreenLoader.stopLoading();
      return;
    }

    if (!reAuthFormKey.currentState!.validate()) {
      MyFullScreenLoader.stopLoading();
      return;
    }

    await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(), verifyPassword.text.trim());
    await AuthenticationRepository.instance.deleteAccount();

    MyFullScreenLoader.stopLoading();
    Get.offAll(() => const LoginScreen());
  } catch (e) {
    MyFullScreenLoader.stopLoading();
    MyLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
  }
}
}