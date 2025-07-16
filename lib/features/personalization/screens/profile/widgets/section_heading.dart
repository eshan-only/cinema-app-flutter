import 'package:flutter/material.dart';

class MySectionHeading extends StatelessWidget {
  const MySectionHeading({
    super.key,
    this.onPressed,
    this.textColor,
    required this.title,
    this.showActionButton = true,
    this.buttonTitle = 'View All',
  });

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall!.apply(color: textColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          TextButton(onPressed: onPressed, child: Text(buttonTitle)),
      ],
    );
  }
}