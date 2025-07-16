import 'package:cinema_app/features/admin_features/navigation_page/movie_management.dart';
import 'package:cinema_app/features/admin_features/user_management.dart';
import 'package:cinema_app/features/movie_discovery/screens/home/home_screen.dart';
import 'package:cinema_app/features/personalization/screens/profile/profile.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NavigationControllerAdmin extends GetxController {
  final Rx<int> selectedIndex= 0.obs;
  final screens = [ HomeScreen(), UserManagement(), MovieManagementPage(), ProfileScreen()];
}