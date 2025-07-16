import 'package:cinema_app/features/authetication/controllers/login/login_controller.dart';
import 'package:cinema_app/utils/constants/colors.dart';
import 'package:cinema_app/utils/constants/image_strings.dart';
import 'package:cinema_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Center( // Centering the content
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.grey),
          borderRadius: BorderRadius.circular(100),
        ),
        child: IconButton(
          onPressed: () => controller.googleSignIn(),
          icon: const Image(
            width: MySizes.iconMd,
            height: MySizes.iconMd,
            image: AssetImage(MyImgStrings.googleLogo),
          ),
        ),
      ),
    );
  }
}
