import 'package:flutter/material.dart';

class ListText extends StatelessWidget {
  const ListText({
    super.key,
    required this.text,
    this.textColor,
    this.maxLines,
    this.fontSize,
  });

  final String text;
  final Color? textColor;
  final int? maxLines;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: fontSize
      ),
      textAlign: TextAlign.center,
      maxLines: maxLines,
    );
  }
}
