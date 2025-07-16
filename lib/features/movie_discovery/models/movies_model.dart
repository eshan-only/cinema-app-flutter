 import 'package:cloud_firestore/cloud_firestore.dart';

// Define Showtime class to store individual showtimes
class Showtime {
  final String time;
  final List<Seat> seats;

  Showtime({required this.time, required this.seats});

  // Factory constructor to create a Showtime object from Firestore map data
  factory Showtime.fromMap(Map<String, dynamic> map) {
    return Showtime(
      time: map['time'] ?? '',
      seats: List<Seat>.from(
        map['seats']?.map((seatData) => Seat.fromMap(seatData)) ?? [],
      ),
    );
  }

  // Convert Showtime object to Firestore map data
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'seats': seats.map((seat) => seat.toMap()).toList(),
    };
  }
}

// Define Seat class to store individual seat data
class Seat {
  final String seatNumber;
  bool isReserved;
  String? userId;

  Seat({required this.seatNumber, this.isReserved = false, this.userId});

  // Factory constructor to create a Seat object from Firestore map data
  factory Seat.fromMap(Map<String, dynamic> map) {
    return Seat(
      seatNumber: map['seatNumber'] ?? '',
      isReserved: map['isReserved'] ?? false,
      userId: map['userId'],
    );
  }

  // Convert Seat object to Firestore map data
  Map<String, dynamic> toMap() {
    return {
      'seatNumber': seatNumber,
      'isReserved': isReserved,
      'userId': userId,
    };
  }
}

// Define Movie class to store movie data and showtimes
class Movie {
  final String movieId;
  final String title;
  final String synopsis;
  final List<String> genres;
  final String rating;
  final List<String> stars;
  final String poster;
  final List<Showtime> showtimes;
  bool isFavorite; // Added field to mark favorite status

  Movie({
    required this.movieId,
    required this.title,
    required this.synopsis,
    required this.genres,
    required this.rating,
    required this.stars,
    required this.poster,
    required this.showtimes,
    this.isFavorite = false, // Default is not favorite
  });
  
  // Convert Firestore document into a Movie object
// Convert Firestore document into a Movie object
factory Movie.fromDocument(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;

  // Handle showtimes array in the document
  var showtimesData = List<Map<String, dynamic>>.from(data['showtimes'] ?? []);
  List<Showtime> showtimes = showtimesData.map((showtimeData) => Showtime.fromMap(showtimeData)).toList();

  return Movie(
    movieId: doc.id,
    title: data['title'] ?? '',
    synopsis: data['synopsis'] ?? '',
    genres: List<String>.from(data['genres'] ?? []),
    rating: data['rating']?.toString() ?? '',
    stars: List<String>.from(data['stars'] ?? []),
    poster: data['poster'] ?? '',
    showtimes: showtimes, // Showtimes now contains Showtime objects
    isFavorite: data['isFavorite'] ?? false, // Fetch favorite status
  );
}

  // Function to toggle favorite status
  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  static List<Showtime> generateShowtimes() {
  // List of predefined times
  List<String> times = ['10:00 AM', '2:00 PM', '5:00 PM', '7:30 PM', '10:00 PM'];

  // Create a list of Showtime objects for each time
  return times.map((time) {
    return Showtime(
      time: time,
      seats: generateSeats(), // Generate a list of seats for each showtime
    );
  }).toList();
}

static List<Seat> generateSeats() {
  // Create a list of 20 seats as an example, you can adjust the number as needed
  List<Seat> seats = [];
  for (int i = 1; i <= 20; i++) {
    seats.add(Seat(seatNumber: 'S$i'));
  }
  return seats;
}
  // Update favorite status in Firestore
  Future<void> updateFavoriteStatus() async {
    try {
      await FirebaseFirestore.instance.collection('Movies').doc(movieId).update({
        'isFavorite': isFavorite, // Update the isFavorite field in Firestore
      });
    } catch (e) {
      print("Error updating favorite status: $e");
    }
  }
}

// Service to handle movie-related Firestore operations
class MovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Counter for the number of movies fetched
  int movieCount = 0;

  // Stream to fetch movies from Firestore
  Stream<List<Movie>> fetchMovies() {
    return _firestore.collection('Movies').snapshots().map((snapshot) {
      // Update the counter with the number of fetched movies
      movieCount = snapshot.docs.length;

      // Convert the snapshot data into a list of Movie objects
      return snapshot.docs.map((doc) => Movie.fromDocument(doc)).toList();
    });
  }

  // Getter for the movie count
  int get movieFetchCount => movieCount;

  // Function to fetch only the showtimes for a specific movie by its ID
  Future<List<Showtime>> fetchShowtimesByMovieId(String movieId) async {
    try {
      // Fetch the movie document by movieId
      DocumentSnapshot doc = await _firestore.collection('Movies').doc(movieId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        // Retrieve the showtimes array from the movie document
        var showtimesData = List<Map<String, dynamic>>.from(data['showtimes'] ?? []);
        
        // Map the showtimes data into Showtime objects
        return showtimesData.map((showtimeData) => Showtime.fromMap(showtimeData)).toList();
      } else {
        // If the movie document doesn't exist, return an empty list
        return [];
      }
    } catch (e) {
      // Handle any errors that occur during fetching
      print('Error fetching showtimes: $e');
      return [];
    }
  }
  
  // Fetch a specific movie by its ID
  Future<Movie?> fetchMovieById(String movieId) async {
    try {
      // Fetch the movie document by movieId
      DocumentSnapshot doc = await _firestore.collection('Movies').doc(movieId).get();

      if (doc.exists) {
        // If the movie document exists, convert it to a Movie object
        return Movie.fromDocument(doc);
      } else {
        // If the movie document doesn't exist, return null
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during fetching
      print('Error fetching movie by ID: $e');
      return null;
    }
  }

  // Function to reserve seats for a specific movie and showtime
  Future<Movie?> reserveSeats(
    String movieId,
    String showtime,
    Set<String> selectedSeats,
    String userId,
  ) async {
    try {
      // Fetch the movie document
      final movieDoc = await _firestore.collection('Movies').doc(movieId).get();
      
      if (movieDoc.exists) {
        // Fetch movie details and update the reserved seats
        final movie = Movie.fromDocument(movieDoc);

        // Find the selected showtime
        final selectedShowtime = movie.showtimes.firstWhere(
          (show) => show.time == showtime,
          orElse: () => Showtime(time: '', seats: []),
        );

        if (selectedShowtime.time.isNotEmpty) {
          // Loop through selected seats and update them to reserved
          for (var seatNumber in selectedSeats) {
            final seatIndex = selectedShowtime.seats.indexWhere(
              (seat) => seat.seatNumber == seatNumber,
            );
            if (seatIndex != -1) {
              selectedShowtime.seats[seatIndex].isReserved = true;
              selectedShowtime.seats[seatIndex].userId = userId;
            }
          }

          // Update the Firestore movie document with the new seat data
          await _firestore.collection('Movies').doc(movieId).update({
            'showtimes': movie.showtimes.map((showtime) => showtime.toMap()).toList(),
          });

          return movie;
        }
      }
    } catch (e) {
      print('Error reserving seats: $e');
    }

    return null;
  }

  // Add a new movie to Firestore
// Add a new movie to Firestore
Future<void> addMovie(Movie movie) async {
  try {
    await _firestore.collection('Movies').add({
      'title': movie.title,
      'synopsis': movie.synopsis,
      'genres': movie.genres,
      'rating': movie.rating,
      'stars': movie.stars,
      'poster': movie.poster,
      'showtimes': movie.showtimes.map((showtime) => showtime.toMap()).toList(), // Convert showtimes to maps
      'isFavorite': movie.isFavorite,
    });
    print('Movie added successfully!');
  } catch (e) {
    print('Error adding movie: $e');
  }
}


  // Update an existing movie by its movieId
  Future<void> updateMovie(Movie movie) async {
    try {
      await _firestore.collection('Movies').doc(movie.movieId).update({
        'title': movie.title,
        'synopsis': movie.synopsis,
        'genres': movie.genres,
        'rating': movie.rating,
        'stars': movie.stars,
        'poster': movie.poster,
        'showtimes': movie.showtimes.map((showtime) => showtime.toMap()).toList(),
        'isFavorite': movie.isFavorite, // Update favorite status
      });
      print('Movie updated successfully!');
    } catch (e) {
      print('Error updating movie: $e');
    }
  }

  // Delete a movie by its movieId
  Future<void> deleteMovie(String movieId) async {
    try {
      await _firestore.collection('Movies').doc(movieId).delete();
      print('Movie deleted successfully!');
    } catch (e) {
      print('Error deleting movie: $e');
    }
  }

  // Search movies (not yet implemented)
  searchMovies(String text) {}
}
