import 'package:flutter/material.dart';

class SectionHeadingText extends StatelessWidget {
  const SectionHeadingText({
    super.key,
    required this.headingText
  });

  final String headingText;

  @override
  Widget build(BuildContext context) {
    return Text(
      headingText,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w600
      ),
    );
  }
}
