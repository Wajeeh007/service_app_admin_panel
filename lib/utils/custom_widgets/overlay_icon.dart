import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/utils/constants.dart';

class OverlayIcon extends StatelessWidget {
  const OverlayIcon({
    super.key,
    required this.iconData,
    required this.onPressed,
    this.left,
    this.top,
    this.bottom,
    this.right,
  });

  final IconData iconData;
  final VoidCallback onPressed;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
        child: CircleAvatar(
            backgroundColor: primaryGrey,
            radius: 10,
            child: InkWell(
              onTap: onPressed,
              child: Icon(
                iconData,
                color: primaryBlack,
                size: 15,
              ),
            )
        )
    );
  }
}
