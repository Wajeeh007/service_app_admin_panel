import 'package:flutter/material.dart';

import '../constants.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    required this.onPressed,
    this.borderRadius,
    this.elevation = 0.0,
    this.buttonColor,
    this.child,
    this.textStyle,
    this.padding = EdgeInsets.zero,
    this.text,
    this.margin,
    this.textColor,
    this.borderColor,
    this.borderWidth = 1,
    this.width = double.infinity,
    this.height = 45
  }) : assert(text != null || child != null, 'Must provide text or child property'),
      assert(text == null || child == null, 'Cannot provide both text and child'),
      assert((text == null && textStyle == null && textColor == null) ||
          (text != null && ((textStyle != null && textColor == null) ||
              (textStyle == null && (textColor != null || textColor == null )))
          ),
      'Cannot provide textStyle and textColor when text is null. Also cannot provide textColor when textStyle is provided'
      );
    // assert((textStyle != null && textColor == null) || (textStyle == null && (textColor != null || textColor == null)), 'textColor must be null when textStyle is provided');

  //TODO: Implement assert statements
  final double elevation;
  final BorderRadiusGeometry? borderRadius;
  final Color? buttonColor;
  final Widget? child;
  final String? text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? margin;
  final Color? textColor;
  final Color? borderColor;
  final double borderWidth;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        minWidth: width,
        height: height,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? kContainerBorderRadius,
          side: BorderSide(
            color: borderColor ?? primaryBlue,
            width: borderWidth
          )
        ),
        elevation: elevation,
        padding: padding,
        color: buttonColor ?? primaryBlue,
        onPressed: onPressed,
        child: text != null ? Text(
          text!,
          style: textStyle ?? Theme.of(context).textTheme.labelLarge?.copyWith(
            color: textColor ?? primaryWhite,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2
          ),
        ) : child,
      ),
    );
  }
}