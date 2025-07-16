
import 'package:cinema_app/features/authetication/controllers/sign_up/sign_up_controller.dart';
import 'package:cinema_app/utils/constants/colors.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:cinema_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsNConditonsCheckBox extends StatelessWidget {
  const TermsNConditonsCheckBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignUpController.instance;
    final dark = MyHelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox( width:24, height: 24, 
        child: Obx(() => Checkbox(
                value: controller.privacyPolicy.value, // Bind to the RxBool value
                onChanged: (value) {
                  if (value != null) {
                    controller.privacyPolicy.value = value; // Update the value on change
                  }
                },
              )),
          ),
        const SizedBox(height: MySizes.spaceBtwItems),
        Text.rich(TextSpan(children: [TextSpan(text: '  ${MyTexts.iAgreeTo} ', style: Theme.of(context).textTheme.labelSmall),
            TextSpan(text: MyTexts.privacyPolicy, style: Theme.of(context).textTheme.labelMedium!.apply(
              color: dark ? MyColors.white:MyColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: dark ? MyColors.white:MyColors.primary,
              )),
            TextSpan(text: ' ${MyTexts.and} ', style: Theme.of(context).textTheme.labelSmall),
            TextSpan(text: MyTexts.termsOfUse, style: Theme.of(context).textTheme.labelMedium!.apply(
              color: dark ? MyColors.white:MyColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: dark ? MyColors.white:MyColors.primary,
              )),
        ])),
      ],
    );
  }
}
