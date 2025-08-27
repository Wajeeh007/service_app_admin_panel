import 'package:flutter/material.dart';

import 'list_entry_item.dart';

class ListSerialNoText extends StatelessWidget {
  const ListSerialNoText({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return ListEntryItem(
      text: (index + 1 > 9 ? index + 1 : '0${index + 1}').toString(),
      shouldExpand: false,
      fontSize: 12.5,
    );
  }
}
