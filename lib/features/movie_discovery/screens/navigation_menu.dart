import 'package:cinema_app/features/movie_discovery/controllers/navigation_controller.dart';
import 'package:cinema_app/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = MyHelperFunctions.isDarkMode(context);

    return Scaffold(
      // Use LayoutBuilder to determine screen size
      body: LayoutBuilder(
        builder: (context, constraints) {
          // If the screen width is larger than a specific threshold (e.g., tablet or desktop)
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                // Navigation on the left for larger screens
                NavigationRail(
                  selectedIndex: controller.selectedIndex.value,
                  onDestinationSelected: (index) => controller.selectedIndex.value = index,
                  backgroundColor: darkMode ? MyColors.black : MyColors.white,
                  indicatorColor: darkMode ? MyColors.white.withOpacity(0.1) : MyColors.black.withOpacity(0.1),
                  selectedLabelTextStyle: TextStyle(color: darkMode ? MyColors.white : MyColors.black),
                  unselectedLabelTextStyle: TextStyle(color: darkMode ? MyColors.white.withOpacity(0.6) : MyColors.black.withOpacity(0.6)),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home_filled), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(CupertinoIcons.compass_fill), label: Text('Explore')),
                    NavigationRailDestination(icon: Icon(CupertinoIcons.ticket_fill), label: Text('Bookings')),
                    NavigationRailDestination(icon: Icon(Icons.person_rounded), label: Text('Profile')),
                  ],
                ),
                // The body part with the selected screen
                Expanded(
                  child: Obx(
                    () => IndexedStack(
                      index: controller.selectedIndex.value,
                      children: controller.screens,
                    ),
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
                  onDestinationSelected: (index) => controller.selectedIndex.value = index,
                  backgroundColor: darkMode ? MyColors.black : MyColors.white,
                  indicatorColor: darkMode ? MyColors.white.withOpacity(0.1) : MyColors.black.withOpacity(0.1),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_filled), label: 'Home'),
                    NavigationDestination(icon: Icon(CupertinoIcons.compass_fill), label: 'Explore'),
                    NavigationDestination(icon: Icon(CupertinoIcons.ticket_fill), label: 'Bookings'),
                    NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
                  ],
                ),
              ),
              body: Obx(
                () => IndexedStack(
                  index: controller.selectedIndex.value,
                  children: controller.screens,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
