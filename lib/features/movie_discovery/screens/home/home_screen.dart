import 'package:cinema_app/common/widgets/custom_shapes/containers/custom_header_container.dart';
import 'package:cinema_app/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:cinema_app/common/widgets/texts/section_heading.dart';
import 'package:cinema_app/features/movie_discovery/controllers/home_page_controller.dart';
import 'package:cinema_app/features/movie_discovery/models/movies_model.dart';
import 'package:cinema_app/features/movie_discovery/screens/home/widgets/home_app_bar.dart';
import 'package:cinema_app/features/movie_discovery/screens/home/widgets/home_categories.dart';
import 'package:cinema_app/features/movie_discovery/screens/movie/movie_details.dart';
import 'package:cinema_app/utils/constants/colors.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';  // To store the search query
  
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final bool dark = MyHelperFunctions.isDarkMode(context);  
    final screenWidth = MediaQuery.of(context).size.width;
    final MovieService movieService = MovieService();
    final Stream<List<Movie>> moviesStream = movieService.fetchMovies();

    return Scaffold(
      backgroundColor: dark ? MyColors.darkestGrey : MyColors.light,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeAppBar(),
                  const SizedBox(height: MySizes.spaceBtwSections),
                  SearchContainer(
                    text: 'Search for a movie',
                    onTap: () {
                      String query = searchController.text.trim();
                      if (query.isNotEmpty) {
                        homeController.updateSearchQuery(query);
                      } else {
                        print('Please enter a movie name!');
                      }
                    },
                  ),
                  const SizedBox(height: MySizes.spaceBtwSections),
                  HomeCategories(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SectionHeading(
                    title: 'Showing this month:',
                    showActionButton: false,
                    textColor: dark ? MyColors.light : MyColors.dark,
                  ),
                  const SizedBox(height: MySizes.spaceBtwSections),
                ],
              ),
            ),
            StreamBuilder<List<Movie>>(
              stream: moviesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching movies: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No movies available.'));
                } else {
                  final movieList = snapshot.data!;

                  // Filter movies based on search query
                  final filteredMovies = movieList.where((movie) {
                    return movie.title.toLowerCase().contains(searchQuery.toLowerCase());
                  }).toList();

                  if (filteredMovies.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No movies found matching your search.'),
                          ElevatedButton(
                            onPressed: () {
                              // Optionally reset search or navigate back
                            },
                            child: const Text('Go back'),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth < 600 ? 2 : 4,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = filteredMovies[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(MovieDetailsPage(movie: movie)); // Using GetX for navigation
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    movie.poster,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  movie.title,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: dark ? Colors.white : Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      movie.rating,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: dark ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
