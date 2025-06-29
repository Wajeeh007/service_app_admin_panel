import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/constants.dart';

class UserStatus extends StatelessWidget {
  const UserStatus({super.key, required this.status});

  final bool status;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 100,
            maxHeight: 40
          ),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: status ? Colors.green : Colors.red,
              width: 1
            ),
            borderRadius: kContainerBorderRadius
          ),
          child: Text(
            '• ${status ? lang_key.active.tr : lang_key.inactive.tr}',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: status ? Colors.green : Colors.red,
            ),
          )
        ),
      ),
    );
  }
}