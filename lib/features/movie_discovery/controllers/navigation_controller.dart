import 'package:cinema_app/features/movie_discovery/screens/home/explore.dart';
import 'package:cinema_app/features/movie_discovery/screens/home/home_screen.dart';
import 'package:cinema_app/features/personalization/screens/bookings.dart';
import 'package:cinema_app/features/personalization/screens/profile/profile.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex= 0.obs;
  final screens = [ HomeScreen(), ExplorePage(), BookingsPage(), ProfileScreen()];
}