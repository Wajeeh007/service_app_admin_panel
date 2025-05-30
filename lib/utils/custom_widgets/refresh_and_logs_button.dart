import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'custom_material_button.dart';

/// Refresh and Logs button
class RefreshAndLogsButton extends StatelessWidget {
  const RefreshAndLogsButton({
    super.key,
    required this.onRefresh
  });

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Tooltip(
          waitDuration: Duration(milliseconds: 800),
          message: 'Refresh List',
          child: CustomMaterialButton(
            onPressed: onRefresh,
            width: 50,
            borderColor: primaryBlue,
            buttonColor: primaryWhite,
            child: Icon(
              Icons.sync,
              color: primaryBlue,
            ),
          ),
        ),
        Tooltip(
          waitDuration: Duration(milliseconds: 800),
          message: 'Check Logs',
          child: CustomMaterialButton(
            onPressed: () {},
            width: 50,
            borderColor: primaryBlue,
            buttonColor: primaryWhite,
            child: Icon(
              CupertinoIcons.clock,
              color: primaryBlue,
            ),
          ),
        ),
      ],
    );
  }
}