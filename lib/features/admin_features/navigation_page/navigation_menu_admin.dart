import 'package:cinema_app/features/admin_features/navigation_controller_admin.dart';
import 'package:cinema_app/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';

class NavigationMenuAdmin extends StatelessWidget {
  const NavigationMenuAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationControllerAdmin());
    final darkMode = MyHelperFunctions.isDarkMode(context);

    return Scaffold(
      // Use LayoutBuilder to determine screen size
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Debugging: print the screen width to ensure the condition is met
          print('Screen width: ${constraints.maxWidth}');

          // If the screen width is larger than a specific threshold (e.g., tablet or desktop)
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                // Navigation on the left for larger screens
                NavigationRail(
                  useIndicator: true,
                  selectedIndex: controller.selectedIndex.value,
                  onDestinationSelected: (index) {
                    // Dynamically set the selected index
                    controller.selectedIndex.value = index;
                  },
                  backgroundColor: darkMode ? MyColors.black : MyColors.white,
                  indicatorColor: darkMode ? MyColors.white.withOpacity(0.1) : MyColors.black.withOpacity(0.1),
                  selectedLabelTextStyle: TextStyle(color: darkMode ? MyColors.white : MyColors.black),
                  unselectedLabelTextStyle: TextStyle(color: darkMode ? MyColors.white.withOpacity(0.6) : MyColors.black.withOpacity(0.6)),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home_filled), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(CupertinoIcons.person_2_fill), label: Text('User Management')),
                    NavigationRailDestination(icon: Icon(CupertinoIcons.film), label: Text('Movies Management')),
                    NavigationRailDestination(icon: Icon(Icons.person_rounded), label: Text('Profile')),
                  ],
                ),
                // The body part with the selected screen
                Expanded(
                  child: Obx(
                    () {
                      print('Selected index for rail: ${controller.selectedIndex.value}');  // Debugging: print selected index
                      return IndexedStack(
                        index: controller.selectedIndex.value,
                        children: controller.screens,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            // Use BottomNavigationBar for smaller screens (mobile)
            return Scaffold(
              bottomNavigationBar: Obx(
                () => NavigationBar(
                  height: 80,
                  elevation: 0,
                  selectedIndex: controller.selectedIndex.value,
                  onDestinationSelected: (index) {
                    // Dynamically set the selected index for smaller screens
                    controller.selectedIndex.value = index;
                  },
                  backgroundColor: darkMode ? MyColors.black : MyColors.white,
                  indicatorColor: darkMode ? MyColors.white.withOpacity(0.1) : MyColors.black.withOpacity(0.1),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_filled), label: 'Home'),
                    NavigationDestination(icon: Icon(CupertinoIcons.person_2_fill), label: 'Users'),
                    NavigationDestination(icon: Icon(CupertinoIcons.film), label: 'Movies'),
                    NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
                  ],
                ),
              ),
              body: Obx(
                () {
                  print('Selected index for bottom nav: ${controller.selectedIndex.value}');  // Debugging: print selected index
                  return IndexedStack(
                    index: controller.selectedIndex.value,
                    children: controller.screens,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
