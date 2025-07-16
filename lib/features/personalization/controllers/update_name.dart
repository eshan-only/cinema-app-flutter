import 'package:cinema_app/data/repositories/user_repository.dart';
import 'package:cinema_app/features/admin_features/navigation_page/navigation_menu_admin.dart'; 
import 'package:cinema_app/features/movie_discovery/screens/navigation_menu.dart';
import 'package:cinema_app/features/personalization/controllers/user_controller.dart';
import 'package:cinema_app/utils/constants/image_strings.dart';
import 'package:cinema_app/utils/helpers/full_screen_loader.dart';
import 'package:cinema_app/utils/helpers/network_manager.dart';
import 'package:cinema_app/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller to manage user-related functionality.
class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormkey = GlobalKey<FormState>();

  // init user data when Home Screen appears
  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  // Fetch user record
  Future<void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }
  
  // Update user name and navigate based on role
  Future<void> updateUserName() async {
    try {
      // Start Loading
      MyFullScreenLoader.openLoadingDialog('We are updating your information...', MyImgStrings.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        MyFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!updateUserNameFormkey.currentState!.validate()) {
        MyFullScreenLoader.stopLoading();
        return;
      }

      // Update user's first & last name in the Firebase Firestore
      Map<String, dynamic> name = {
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim()
      };
      await userRepository.updateSingleField(name);

      // Update the Rx User value
      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();

      // Get the user's role
      String role = userController.user.value.role; // Assuming `role` is a field in user data

      // Remove Loader
      MyFullScreenLoader.stopLoading();

      // Show Success Message
      MyLoaders.successSnackBar(title: 'Congratulations', message: 'Your Name has been updated.');

      // Navigate based on role
      if (role == 'Admin') {
        Get.off(() => const NavigationMenuAdmin());
      } else {
        Get.off(() => const NavigationMenu());
      }
    } catch (e) {
      MyFullScreenLoader.stopLoading();
      MyLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
