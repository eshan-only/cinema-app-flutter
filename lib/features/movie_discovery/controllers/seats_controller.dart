import 'package:get/get.dart';

class SeatSelectionController extends GetxController {
  var selectedSeats = <String>{}.obs; // Reactive set of selected seats
  var reservedSeats = <String>{}.obs; // Reactive set of reserved seats
  var isLoading = true.obs; // Loading state
  var selectedShowtime = ''.obs; // Selected showtime

  void updateSelectedSeats(Set<String> seats) {
    selectedSeats.value = seats;
  }

  void updateReservedSeats(Set<String> seats) {
    reservedSeats.value = seats;
  }

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void setSelectedShowtime(String showtime) {
    selectedShowtime.value = showtime;
  }
}
