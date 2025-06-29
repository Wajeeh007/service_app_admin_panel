import 'package:flutter/material.dart';

import 'list_entry_item.dart';
import 'list_text.dart';

class ContactInfoInList extends StatelessWidget {
  const ContactInfoInList({
    super.key,
    required this.email,
    required this.phoneNo,
  });

  final String email;
  final String phoneNo;

  @override
  Widget build(BuildContext context) {
    return ListEntryItem(
      child: Column(
        children: [
          ListText(text: phoneNo),
          ListText(text: email, maxLines: 1,),
        ],
      ),
    );
  }
}