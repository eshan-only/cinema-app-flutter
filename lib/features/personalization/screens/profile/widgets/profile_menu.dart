import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyProfileMenu extends StatelessWidget {
  const MyProfileMenu({
    super.key,
    required this.onPressed,
    required this.title,
    required this.value,
    // this.showIcon = true, // Added boolean for icon visibility
    this.icon = Iconsax.arrow_right_3,
  });

  final IconData icon;
  // final bool showIcon; // Boolean to toggle the icon
  final VoidCallback onPressed;
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: MySizes.spaceBtwItems / 1.5),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // if (showIcon) // Conditional rendering of the icon
            //   Expanded(child: Icon(icon, size: 18)),
          ],
        ),
      ),
    );
  }
}
