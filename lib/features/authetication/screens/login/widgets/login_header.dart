import 'package:cinema_app/utils/constants/image_strings.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the Row's children
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10), // Adjust padding if needed
              child: Image(
                height: 69,
                image: AssetImage(dark ? MyImgStrings.darkAppLogo : MyImgStrings.lightAppLogo),
              ),
            ),
          ],
        ),
        const SizedBox(height: MySizes.sm),
        Center(child: Text(MyTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium)),
        Center(child: Text(MyTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}
