import 'package:cinema_app/features/movie_discovery/models/movies_model.dart';
import 'package:cinema_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:cinema_app/data/repositories/authentication/cloudinary.dart';
import 'package:file_picker/file_picker.dart';

class MovieManagementPage extends StatefulWidget {
  const MovieManagementPage({super.key});

  @override
  _MovieManagementPageState createState() => _MovieManagementPageState();
}

class _MovieManagementPageState extends State<MovieManagementPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MovieService _movieService = MovieService();
  late String link;

  // Form fields
  String _title = '';
  String _synopsis = '';
  String _rating = '';
  String _poster = '';
  late TextEditingController _posterController;
  List<String> _genres = [];
  List<String> _stars = [];
  FilePickerResult? _filePickerResult;

  // To hold the list of movies fetched from Firestore
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _posterController = TextEditingController();
    _fetchMovies();
  }

  @override
  void dispose() {
    _posterController.dispose();
    super.dispose();
  }

  // Fetch all movies from Firestore
  void _fetchMovies() {
    _movieService.fetchMovies().listen((movies) {
      setState(() {
        _movies = movies;
      });
    });
  }

  // Add a new movie to Firestore
  void _addMovie() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Movie'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  onSaved: (value) => _title = value!,
                  validator: (value) => MyValidator.validateEmptyText("Title", value),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Synopsis'),
                  onSaved: (value) => _synopsis = value!,
                  validator: (value) => MyValidator.validateEmptyText("Synopsis", value),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Rating'),
                  onSaved: (value) => _rating = value!,
                  validator: (value) => MyValidator.validateEmptyText("Rating", value),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    
                    Expanded(
                      child: TextFormField(
                        controller: _posterController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Poster URL',
                          hintText: _poster.isNotEmpty ? 'Poster URL: $_poster' : 'No poster uploaded yet',
                        ),
                        onSaved: (value) {
                          _poster = value!;
                        },
                      ),
                    ),
                     SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.upload, size: 20),
                      
                      onPressed: _selectAndUploadFile,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      ),
                    ),
                  
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Genres (comma-separated)'),
                  onSaved: (value) => _genres = value!.split(',').map((e) => e.trim()).toList(),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Stars (comma-separated)'),
                  onSaved: (value) => _stars = value!.split(',').map((e) => e.trim()).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Movie newMovie = Movie(
                  movieId: '',
                  title: _title,
                  synopsis: _synopsis,
                  genres: _genres,
                  rating: _rating,
                  stars: _stars,
                  poster: _poster,
                  showtimes: Movie.generateShowtimes(),
                );
                try {
                  _movieService.addMovie(newMovie).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Movie added successfully!')),
                    );
                    Navigator.of(context).pop(); // Close the dialog
                    _fetchMovies(); // Refresh movies list
                  }).catchError((e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding movie: $e')),
                    );
                  });
                } catch (e) {
                  print('Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add movie: $e')),
                  );
                }
              }
            },              child: const Text('Add Movie'),
            ),
          ],
        );
      },
    );
  }

  
  Future<void> _selectAndUploadFile() async {
    print("Starting file selection...");
    
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      allowedExtensions: ["jpg", "jpeg", "png", "mp4"],
      type: FileType.custom,
    );

    if (result != null) {
      print("File selected: ${result.files.single.name}");

      // Upload the file to Cloudinary and get the secure URL
      final secureUrl = await uploadToCloudinary(result);

      if (secureUrl != null) {
        print("Upload successful. Secure URL: $secureUrl");

        setState(() {
          // Set the secure URL directly into the _posterController
          _posterController.text = secureUrl;  // Update the poster field with the secure URL
        });

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File uploaded successfully!")),
        );
      } else {
        // Handle missing secure_url in the response
        print("Error: 'secure_url' missing in the response.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to get the uploaded file URL.")),
        );
      }
    } else {
      print("No file selected.");
    }
  }
  // Update an existing movie in Firestore
  void _updateMovie(Movie movie) {
    _title = movie.title;
    _synopsis = movie.synopsis;
    _rating = movie.rating;
    _poster = movie.poster;
    _genres = movie.genres;
    _stars = movie.stars;

    // Show the form to update the movie
    _showMovieForm(movie);
  }

  // Show the form for updating a movie
  void _showMovieForm(Movie movie) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Movie: ${movie.title}'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (value) => _title = value!,
                  validator: (value) => MyValidator.validateEmptyText("Title", value),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _synopsis,
                  decoration: InputDecoration(labelText: 'Synopsis'),
                  onSaved: (value) => _synopsis = value!,
                  validator: (value) => MyValidator.validateEmptyText("Synopsis", value),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _rating,
                  decoration: InputDecoration(labelText: 'Rating'),
                  onSaved: (value) => _rating = value!,
                  validator: (value) => MyValidator.validateEmptyText("Rating", value),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _poster,
                  decoration: InputDecoration(labelText: 'Poster URL'),
                  onSaved: (value) => _poster = value!,
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _genres.join(', '),
                  decoration: InputDecoration(labelText: 'Genres (comma-separated)'),
                  onSaved: (value) => _genres = value!.split(',').map((e) => e.trim()).toList(),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: _stars.join(', '),
                  decoration: InputDecoration(labelText: 'Stars (comma-separated)'),
                  onSaved: (value) => _stars = value!.split(',').map((e) => e.trim()).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Movie updatedMovie = Movie(
                    movieId: movie.movieId,
                    title: _title,
                    synopsis: _synopsis,
                    genres: _genres,
                    rating: _rating,
                    stars: _stars,
                    poster: _poster,
                    showtimes: movie.showtimes, // Keep existing showtimes
                  );

                  _movieService.updateMovie(updatedMovie);
                  Navigator.of(context).pop(); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Movie updated successfully!')),
                  );
                  _fetchMovies(); // Refresh movie list
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Delete a movie
  void _deleteMovie(String movieId) {
    _movieService.deleteMovie(movieId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Movie deleted successfully!')),
    );
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addMovie, // Show Add Movie dialog when pressed
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            // Movie List
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  Movie movie = _movies[index];
                  return Card(
                    child: ListTile(
                      title: Text(movie.title),
                      subtitle: Text(movie.synopsis),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _updateMovie(movie),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteMovie(movie.movieId),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
