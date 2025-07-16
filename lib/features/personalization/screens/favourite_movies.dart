import 'package:cinema_app/features/movie_discovery/screens/movie/movie_details.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinema_app/features/movie_discovery/models/movies_model.dart';

class FavouriteMoviesPage extends StatefulWidget {
  final String userId;

  const FavouriteMoviesPage({super.key, required this.userId});

  @override
  State<FavouriteMoviesPage> createState() => _FavouriteMoviesPageState();
}

class _FavouriteMoviesPageState extends State<FavouriteMoviesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MovieService _movieService = MovieService();
  List<Movie> favouriteMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavouriteMovies();
  }

  // Fetch favourite movies
  Future<void> fetchFavouriteMovies() async {
    try {
      // Fetch the user's document
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(widget.userId).get();

      if (userDoc.exists) {
        // Get the favourite_movies array
        List<dynamic> favouriteMovieIds = userDoc.get('favourite_movies') ?? [];

        // Fetch details of each favourite movie
        List<Movie> movies = [];
        for (String movieId in favouriteMovieIds) {
          Movie? movie = await _movieService.fetchMovieById(movieId);
          if (movie != null) {
            movie.isFavorite = true; // Mark the movie as favorite
            movies.add(movie);
          }
        }

        // Update the state with fetched movies
        setState(() {
          favouriteMovies = movies;
          isLoading = false;
        });
      } else {
        // No user document found
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching favourite movies: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = MyHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favourite Movies',
          style: TextStyle(
            color: dark ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favouriteMovies.isEmpty
              ? Center(
                  child: Text(
                    'No favourite movies found.',
                    style: TextStyle(
                      color: dark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: favouriteMovies.length,
                  itemBuilder: (context, index) {
                    final movie = favouriteMovies[index];
                    return Card(
                      color: dark ? Colors.grey[900] : Colors.white,
                      child: ListTile(
                        leading: Image.network(
                          movie.poster,
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          movie.title,
                          style: TextStyle(
                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          movie.genres.join(', '),
                          style: TextStyle(
                            color: dark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsPage(movie: movie),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
