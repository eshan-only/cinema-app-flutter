import 'package:cinema_app/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:cinema_app/common/widgets/custom_shapes/curved_edges/curved_widgets.dart';
import 'package:cinema_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomHeaderContainer extends StatelessWidget {
  const CustomHeaderContainer({
    super.key, 
    required this.child,
    this.height = 300, // Default height is 300 if not provided
  });

  final Widget child;
  final double height; // The height parameter

  @override
  Widget build(BuildContext context) {
    return CurvedEdgesWidget(
      child: Container(
        color: MyColors.darkerGrey,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: height, // Use the height parameter here
          child: Stack(
            children: [
              Positioned(
                top: -200, right: -250,
                child: MyCircularContainer(backgroundColor: MyColors.white.withOpacity(0.1)),
              ),
              Positioned(
                top: 50, right: -300,
                child: MyCircularContainer(backgroundColor: MyColors.white.withOpacity(0.1)),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
