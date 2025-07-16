import 'package:cinema_app/common/widgets/appBar/appbar.dart';
import 'package:cinema_app/features/personalization/controllers/user_controller.dart';
import 'package:cinema_app/features/personalization/screens/favourite_movies.dart';
import 'package:cinema_app/utils/constants/colors.dart';
import 'package:cinema_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return MyAppBar(
      title: Column(
        children: [
          Text(MyTexts.homeAppbarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: MyColors.grey),),
          Obx(() => Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: MyColors.grey),)),
        ],
      ),
      actions: [
        IconButton(onPressed: () {
            // Navigate to FavouriteMoviesPage
            Get.to(() => FavouriteMoviesPage(userId: controller.user.value.id,));
          }, icon: const Icon(Icons.favorite), color: Colors.red)
      ],
    );
  }
}
