import 'package:cinema_app/common/widgets/image_text/verical_img_text.dart';
import 'package:cinema_app/common/widgets/texts/section_heading.dart';
import 'package:cinema_app/features/movie_discovery/models/category_model.dart';
import 'package:cinema_app/features/movie_discovery/models/movies_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'categories_page.dart';
import 'package:cinema_app/utils/constants/sizes.dart';

class HomeCategories extends StatelessWidget {

  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Movie>>(
      stream: MovieService().fetchMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No movies found.'));
        }

        final movies = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.only(left: MySizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                title: 'Genres',
                showActionButton: false,
                textColor: Colors.white,
              ),
              const SizedBox(height: MySizes.spaceBtwItems),

              // Categories with horizontal sliding
              SizedBox(
                height: 80,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    final category = categories[index]['title']!;
                    final image = categories[index]['image']!;

                    return VerticalImageText(
                      title: category,
                      image: image,
                      onTap: () {
                        // Filter movies for the selected category
                        final filteredMovies = movies.where((movie) {
                          return movie.genres.contains(category);
                        }).toList();

                        // Navigate to the CategoriesPage with filtered movies
                        Get.to(() => CategoriesPage(
                              title: category,
                              color: Colors.primaries[index % Colors.primaries.length],
                              movies: filteredMovies,
                            ));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
