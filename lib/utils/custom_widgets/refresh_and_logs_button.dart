import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'custom_material_button.dart';

/// Refresh and Logs button
class RefreshAndLogsButton extends StatelessWidget {
  const RefreshAndLogsButton({
    super.key,
    this.onRefresh,
    this.onLogsPressed,
    this.showLogs = true,
    this.showRefresh = true,
  }) : assert((showRefresh && onRefresh != null) || (showRefresh == false && onRefresh == null), 'If refresh button is shown then function must be provided and vice-versa');

  final VoidCallback? onRefresh;
  final VoidCallback? onLogsPressed;
  final bool showRefresh;
  final bool showLogs;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Visibility(
          visible: showRefresh,
          child: Tooltip(
            waitDuration: Duration(milliseconds: 800),
            message: 'Refresh List',
            child: CustomMaterialButton(
              onPressed: onRefresh ?? () {},
              width: 50,
              borderColor: primaryBlue,
              buttonColor: primaryWhite,
              child: Icon(
                Icons.sync,
                color: primaryBlue,
              ),
            ),
          ),
        ),
        Visibility(
          visible: showLogs,
          child: Tooltip(
            waitDuration: Duration(milliseconds: 800),
            message: 'Check Logs',
            child: CustomMaterialButton(
              onPressed: onLogsPressed ?? () {},
              width: 50,
              borderColor: primaryBlue,
              buttonColor: primaryWhite,
              child: Icon(
                CupertinoIcons.clock,
                color: primaryBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}