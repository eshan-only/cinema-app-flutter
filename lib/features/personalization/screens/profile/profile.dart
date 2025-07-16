import 'package:cinema_app/common/widgets/appBar/appbar.dart';
import 'package:cinema_app/common/widgets/image/circular_image.dart';
import 'package:cinema_app/data/repositories/authentication/authentication_repository.dart';
import 'package:cinema_app/features/personalization/controllers/user_controller.dart';
import 'package:cinema_app/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:cinema_app/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:cinema_app/features/personalization/screens/profile/widgets/section_heading.dart';
import 'package:cinema_app/utils/constants/image_strings.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';
import 'package:cinema_app/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    // Print user details to the terminal
    printUserDetails(controller);

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const MyAppBar(
        showBackArrow: false,
        title: Text('Profile'),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(MySizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const MyCircularImage(
                        image: MyImgStrings.userDefault,
                        width: 80,
                        height: 80,
                      ),
                      SizedBox(height: 30,)
                      // TextButton(
                      //   onPressed: () {},
                      //   child: const Text('Change Profile Photo'),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: MySizes.spaceBtwItems / 2),
                const Divider(),
                const SizedBox(height: MySizes.spaceBtwItems),
                // Profile Information Section
                const MySectionHeading(
                  title: 'Profile Information',
                  showActionButton: false,
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                _buildProfileMenuList(controller, screenWidth),
                const Divider(),
                const SizedBox(height: MySizes.spaceBtwItems),
                // Personal Information Section
                const MySectionHeading(
                  title: 'Personal Information',
                  showActionButton: false,
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                _buildPersonalInfoList(controller),
                const Divider(),
                const SizedBox(height: MySizes.spaceBtwItems),
                // Account Actions
                Center(
                  child: TextButton(
                    onPressed: () => showConfirmationPopup(
                      title: 'Delete Account',
                      message:
                          'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
                      confirmButtonText: 'Delete',
                      onConfirm: () {
                        controller.deleteUserAccount();
                        Navigator.of(Get.overlayContext!).pop();
                      },
                    ),
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      showConfirmationPopup(
                        title: 'Logout',
                        message: 'Are you sure you want to log out?',
                        confirmButtonText: 'Logout',
                        onConfirm: () async {
                          try {
                            await AuthenticationRepository.instance.logout();
                          } catch (e) {
                            Get.snackbar('Error', e.toString(),
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                      );
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Build Profile Menu List Responsively
  Widget _buildProfileMenuList(UserController controller, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyProfileMenu(
          title: 'Name',
          value:
              "${controller.user.value.firstName} ${controller.user.value.lastName}",
          onPressed: () => Get.to(() => const ChangeName()),
        ),
        MyProfileMenu(
          title: 'Username',
          value: controller.user.value.username,
          // showIcon: false,
          onPressed: () {},
        ),
      ],
    );
  }

  // Build Personal Information List
  Widget _buildPersonalInfoList(UserController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyProfileMenu(
          title: 'User ID',
          value: controller.user.value.id,
          icon: Iconsax.copy,
          onPressed: () async {
            await MyHelperFunctions.copyToClipboard(controller.user.value.id);
            MyLoaders.successSnackBar(
              title: 'Copied',
              message: 'User ID copied to clipboard!',
            );
          },
        ),
        MyProfileMenu(
          title: 'E-mail',
          // showIcon: false,
          value: controller.user.value.email,
          onPressed: () {},
        ),
        MyProfileMenu(
          title: 'Phone Number',
          // showIcon: false,
          value: controller.user.value.phoneNumber,
          onPressed: () {},
        ),
      ],
    );
  }

  // Function to print user details to terminal
  void printUserDetails(UserController controller) {
    final user = controller.user.value;
    print("User ID: ${user.id}");
    print("Full Name: ${user.fullName}");
    print("Username: ${user.username}");
    print("Email: ${user.email}");
    print("Phone Number: ${user.phoneNumber}");
  }

  // Generic confirmation popup function
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
}
