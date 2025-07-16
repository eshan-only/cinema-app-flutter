import 'package:cinema_app/utils/constants/colors.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class VerticalImageText extends StatelessWidget {
  // Declare title and image as final
  final String title;
  final String image;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  const VerticalImageText({
    super.key,
    required this.title,
    required this.image,
    this.textColor = MyColors.white,
    this.backgroundColor = MyColors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: MySizes.spaceBtwItems),
        child: Column(
          children: [
            // Circular image container with background color
            Container(
              width: 53,
              height: 53,
              padding: const EdgeInsets.all(MySizes.sm),
              decoration: BoxDecoration(
                color: backgroundColor ?? (dark ? MyColors.black : MyColors.white), // Use 'color' here
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Text
            const SizedBox(height: MySizes.spaceBtwItems / 2),
            SizedBox(
              width: 50,
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelMedium!.apply(color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
