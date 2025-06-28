import 'package:flutter/material.dart';

class ListText extends StatelessWidget {
  const ListText({
    super.key,
    required this.text,
    this.textColor,
    this.maxLines
  });

  final String text;
  final Color? textColor;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600
      ),
      textAlign: TextAlign.center,
      maxLines: maxLines,
    );
  }
}
