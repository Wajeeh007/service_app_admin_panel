import 'package:flutter/material.dart';

class HeadingInContainerText extends StatelessWidget {
  const HeadingInContainerText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold
      ),
    );
  }
}
