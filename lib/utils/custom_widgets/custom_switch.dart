import 'package:flutter/cupertino.dart';
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
    return Transform.scale(
      scale: 0.80,
      child: CupertinoSwitch(
        trackOutlineWidth: WidgetStatePropertyAll(15.0),
            value: switchValue,
            onChanged: onChanged,
          thumbColor: primaryBlue,
          activeTrackColor: primaryBlue.withValues(alpha: 0.2),
          inactiveThumbColor: primaryGrey,
          inactiveTrackColor: primaryGrey20,
      ),
    );
  }
}