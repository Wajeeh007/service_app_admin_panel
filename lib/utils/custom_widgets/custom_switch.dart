import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.switchValue,
    required this.onChanged,
  });

  final bool switchValue;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Switch(
          value: switchValue,
          onChanged: onChanged,
        activeColor: primaryBlue,
        activeTrackColor: primaryBlue.withValues(alpha: 0.2),
        inactiveThumbColor: primaryGrey,
        inactiveTrackColor: primaryGrey20,
      ),
    );
  }
}
