import 'package:cinema_app/common/styles/spacing_styles.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subTitle, required this.onPressed});

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: MySpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
               // Image
              Image(image: AssetImage(image), width: MyHelperFunctions.screenWidth()*0.6,),
              const SizedBox(height: MySizes.spaceBtwSections,),

              // Title and Subtitle
              Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: MySizes.spaceBtwItems,),
              Text(subTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: MySizes.spaceBtwSections),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: onPressed, child: const Text(MyTexts.continueButton)),
              )
            ],
          ),
        ),
      ),
    );
  }
}