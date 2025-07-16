import 'package:cinema_app/features/movie_discovery/models/movies_model.dart';
import 'package:cinema_app/features/personalization/controllers/user_controller.dart';
import 'package:cinema_app/features/ticket_booking/models/ticket.dart';
import 'package:cinema_app/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SeatSelectionPage extends StatefulWidget {
  final String movieId;

  const SeatSelectionPage({super.key, required this.movieId});

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MovieService _movieService = MovieService();

  String? selectedShowtime;
  Set<String> reservedSeats = {};
  Set<String> selectedSeats = {};
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final int seatPrice = 500;
  bool isLoading = true;

  Movie? movie;

  @override
  void initState() {
    super.initState();
    fetchMovieAndShowtimes();
  }

  Future<void> fetchMovieAndShowtimes() async {
    try {
      final movieDoc = await _firestore.collection('Movies').doc(widget.movieId).get();
      if (movieDoc.exists) {
        movie = Movie.fromDocument(movieDoc);
        if (movie != null && movie!.showtimes.isNotEmpty) {
          selectedShowtime = movie!.showtimes[0].time;
          fetchReservedSeats();
        }
      }
    } catch (e) {
      print('Error fetching movie: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchReservedSeats() async {
    if (selectedShowtime == null || movie == null) return;
    try {
      final selectedShowtimeData = movie!.showtimes.firstWhere(
        (show) => show.time == selectedShowtime,
        orElse: () => Showtime(time: '', seats: []),
      );
      if (selectedShowtimeData.seats.isNotEmpty) {
        reservedSeats = selectedShowtimeData.seats
            .where((seat) => seat.isReserved)
            .map((seat) => seat.seatNumber)
            .toSet();
      }
      setState(() {});
    } catch (e) {
      print('Error fetching reserved seats: $e');
    }
  }

  Future<void> reserveSeats() async {
    final controller = Get.put(UserController());
    if (selectedSeats.isEmpty || movie == null) return;

    try {
      final updatedMovie = await _movieService.reserveSeats(
        widget.movieId,
        selectedShowtime!,
        selectedSeats,
        userId,
      );

      Ticket ticket = Ticket(
        userId: userId,
        numberOfSeats: selectedSeats.length,
        seatNames: selectedSeats.toList(),
        totalPrice: selectedSeats.length * seatPrice,
        userPhoneNumber: controller.user.value.phoneNumber,
        userEmail: controller.user.value.email,
        movieName: movie?.title ?? 'Unknown Movie',
        movieTiming: selectedShowtime!,
        bookingDate: DateTime.now().toString(),
      );

      if (updatedMovie != null) {
        setState(() {
          reservedSeats.addAll(selectedSeats);
          selectedSeats.clear();
        });

        movie = await _movieService.fetchMovieById(widget.movieId);
        final ticketDoc = await _firestore.collection('Tickets').add(ticket.toMap());
        await _firestore.collection('Users').doc(userId).update({
          'tickets': FieldValue.arrayUnion([ticketDoc.id]),
        });

        MyLoaders.successSnackBar(
          title: 'Booking Successful!',
          message: 'Booking confirmed for: ${selectedSeats.toList()}',
        );
      }
    } catch (e) {
      print('Error reserving seats: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error booking seats. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    int totalPrice = selectedSeats.length * seatPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Seats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choose your showtime',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (!isLoading && movie != null)
              Wrap(
                spacing: 10,
                alignment: WrapAlignment.center,
                children: movie!.showtimes.map((showtime) {
                  return ChoiceChip(
                    label: Text(showtime.time),
                    selected: selectedShowtime == showtime.time,
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          selectedShowtime = showtime.time;
                          reservedSeats.clear();
                          fetchReservedSeats();
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            if (selectedShowtime != null)
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isSmallScreen ? 3 : 5,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: movie?.showtimes
                          .firstWhere(
                            (show) => show.time == selectedShowtime,
                            orElse: () => Showtime(time: '', seats: []),
                          )
                          .seats
                          .length ??
                      0,
                  itemBuilder: (context, index) {
                    final seat = movie!.showtimes
                        .firstWhere(
                          (show) => show.time == selectedShowtime,
                          orElse: () => Showtime(time: '', seats: []),
                        )
                        .seats[index];

                    Color seatColor = reservedSeats.contains(seat.seatNumber)
                        ? Colors.grey
                        : selectedSeats.contains(seat.seatNumber)
                            ? Colors.blue
                            : Colors.green;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!reservedSeats.contains(seat.seatNumber)) {
                            if (selectedSeats.contains(seat.seatNumber)) {
                              selectedSeats.remove(seat.seatNumber);
                            } else {
                              selectedSeats.add(seat.seatNumber);
                            }
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: seatColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            seat.seatNumber,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              'Total Price: $totalPrice PKR',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedSeats.isNotEmpty ? reserveSeats : null,
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
