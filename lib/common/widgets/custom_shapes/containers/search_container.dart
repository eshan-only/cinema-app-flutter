import 'package:cinema_app/features/movie_discovery/controllers/home_page_controller.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key, 
    required this.text, 
    this.icon = Iconsax.search_normal, 
    this.showBackground = true, 
    this.showBorder = true, 
    required this.onTap,
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunctions.isDarkMode(context);
    final HomeController homeController = Get.find(); // Use Get.find() to access HomeController
    
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: SizedBox(
          width: 300,
          child: Row(
            children: [
              const SizedBox(width: MySizes.spaceBtwItems),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: text,
                    border: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    suffixIcon: Icon(
                      icon, 
                      color: dark ? Colors.white : Colors.black, // Change color based on dark mode
                    ),
                  ),
                  onChanged: (query) {
                    // Handle the search query
                    homeController.updateSearchQuery(query);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
