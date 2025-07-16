import 'package:cinema_app/features/movie_discovery/models/movies_model.dart';
import 'package:cinema_app/features/movie_discovery/screens/movie/movie_details.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  var pageOffset = 1.0.obs;
  var currentIndex = 1.obs;

  // Controller for the page view
  late PageController controller;

  // Observable list for movies
  var movies = <Movie>[].obs; 

  // Service instance to fetch movies
  final MovieService movieService = MovieService();

  // Initialize the PageController and add listener
  @override
  void onInit() {
    super.onInit();
    controller = PageController(
      initialPage: 1,
      viewportFraction: 0.6,
    )..addListener(() {
        pageOffset.value = controller.page!;
      });

    // Fetch movies from Firestore
    movieService.fetchMovies().listen((movieList) {
      movies.value = movieList;  // Update the observable list
    });
  }

  var searchQuery = ''.obs;

  // Function to update the search query and fetch the movie
  void updateSearchQuery(String query) {
    searchQuery.value = query.trim();

    if (searchQuery.isEmpty) {
      print('Search query is empty');
      return;
    }

    // Perform search for the movie
    final movie = movies.firstWhere(
      (movie) => movie.title.toLowerCase() == searchQuery.toLowerCase(),
      orElse: () => Movie(
        title: 'No Movie Found',
        poster: '',
        synopsis: '',
        rating: 'N/A',
        movieId: '',
        showtimes: [],
        genres: [],
        stars: [],
      ),
    );

    if (movie.title != 'No Movie Found') {
      Get.to(MovieDetailsPage(movie: movie));
    } else {
    print('Movie not found!');
    }
  }

  // Dispose the controller when not needed
  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
