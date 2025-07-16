import 'package:cinema_app/features/movie_discovery/screens/movie/seat_selection.dart';
import 'package:cinema_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cinema_app/features/movie_discovery/models/movies_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not logged in
      return;
    }

    final userId = user.uid;
    final userDocRef = FirebaseFirestore.instance.collection('Users').doc(userId);

    try {
      final userDoc = await userDocRef.get();
      if (userDoc.exists) {
        final favoriteMovies = List<String>.from(userDoc['favourite_movies'] ?? []);
        setState(() {
          isFavorite = favoriteMovies.contains(widget.movie.movieId);
        });
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch favorite status: $e')),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Show an error if the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to favorite movies!')),
      );
      return;
    }

    final userId = user.uid;
    final userDocRef = FirebaseFirestore.instance.collection('Users').doc(userId);

    try {
      // Toggle the favorite status
      setState(() {
        isFavorite = !isFavorite;
      });

      // Update the favorite movies array in Firestore
      if (isFavorite) {
        await userDocRef.update({
          'favourite_movies': FieldValue.arrayUnion([widget.movie.movieId]),
        });
      } else {
        await userDocRef.update({
          'favourite_movies': FieldValue.arrayRemove([widget.movie.movieId]),
        });
      }

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite
                ? '${widget.movie.title} added to favorites!'
                : '${widget.movie.title} removed from favorites!',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorites: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        backgroundColor: dark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
          color: dark ? Colors.white : Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : (dark ? Colors.white : Colors.black),
            ),
            onPressed: _toggleFavorite, // Call the favorite toggle function
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.movie.poster,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.movie.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: dark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.movie.genres
                  .map((genre) => Chip(
                        label: Text(genre),
                        backgroundColor:
                            dark ? Colors.grey[800] : Colors.grey[300],
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.movie.rating,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: dark ? Colors.white : Colors.black,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Synopsis",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.black,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.movie.synopsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: dark ? Colors.white70 : Colors.black87,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              "Cast",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.black,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.movie.stars
                  .map((star) => Chip(
                        label: Text(star),
                        backgroundColor:
                            dark ? Colors.grey[800] : Colors.grey[300],
                      ))
                  .toList(),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeatSelectionPage(movieId: widget.movie.movieId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  iconColor: MyColors.primary, // Use the accent color for the button
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  elevation: 5, // Add shadow for depth
                ),
                child: Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
