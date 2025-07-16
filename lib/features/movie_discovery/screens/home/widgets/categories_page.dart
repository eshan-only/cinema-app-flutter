import 'package:cinema_app/features/movie_discovery/models/movies_model.dart';
import 'package:cinema_app/features/movie_discovery/screens/movie/movie_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import the Movie model

class CategoriesPage extends StatelessWidget {
  final String title;
  final Color color;
  final List<Movie> movies;  // Update to accept List<Movie>

  const CategoriesPage({
    super.key,
    required this.title,
    required this.color,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
      ),
      body: Container(
        color: color.withOpacity(0.1),
        child: movies.isEmpty
            ? Center(
                child: Text(
                  'No movies available in $title.',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(movie.poster ?? ''),
                        onBackgroundImageError: (_, __) =>
                            const Icon(Icons.movie, size: 40),
                      ),
                      title: Text(
                        movie.title ?? 'Unknown Title',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        movie.synopsis ?? 'No description available.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () {
                        Get.to(MovieDetailsPage(movie: movie));
                        print('Selected movie: ${movie.title}');
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
