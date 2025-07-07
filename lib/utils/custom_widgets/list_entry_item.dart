import 'package:flutter/material.dart';

import 'list_text.dart';

class ListEntryItem extends StatelessWidget {
  const ListEntryItem({
    super.key,
    this.child,
    this.shouldExpand = true,
    this.text,
    this.maxLines,
    this.fontSize
  }) : assert(child == null || text == null, 'child and text cannot be provided at the same time'),
      assert(child != null || text != null, 'child or text must be provided');

  final Widget? child;
  final bool shouldExpand;
  final String? text;
  final int? maxLines;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return shouldExpand ? Expanded(
        child: child != null ? child! : ListText(
            text: text!,
          maxLines: maxLines,
          fontSize: fontSize,
        )
    ) : child != null ? child! : ListText(
      text: text!,
      maxLines: maxLines,
      fontSize: fontSize,
    );
  }
}
