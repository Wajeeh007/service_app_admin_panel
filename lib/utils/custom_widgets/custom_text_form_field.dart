import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 8,
    ),
    this.initialValue,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.autoValidateMode,
    this.hint,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.onTap,
    this.minLines,
    this.showCursor,
    this.suffixIcon,
    this.prefixIconSize,
    this.suffixIconSize,
    this.fillColor,
    this.prefixIcon,
    this.errorText,
    this.readOnly = false,
    this.inputFormatters,
    this.suffixOnPressed,
    this.onFieldSubmitted,
    this.textAlign = TextAlign.start,
    this.prefix,
    this.prefixText,
    this.prefixTextStyle,
    this.title,
    this.enabled,
  });

  final String? hint;
  final Widget? prefix;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;
  final GestureTapCallback? onTap;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final AutovalidateMode? autoValidateMode;
  final bool? showCursor;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final Color? fillColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? prefixIconSize;
  final double? suffixIconSize;
  final EdgeInsetsGeometry contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? suffixOnPressed;
  final void Function(String)? onFieldSubmitted;
  final TextAlign textAlign;
  final String? prefixText;
  final TextStyle? prefixTextStyle;
  final String? title;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if(title != null && title != '') Padding(
          padding: EdgeInsets.only(left: 8, bottom: 5),
          child: Text(
            title!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500
            ),
          ),
        ),
        TextFormField(
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          minLines: minLines,
          onTap: onTap,
          initialValue: initialValue,
          showCursor: showCursor,
          controller: controller,
          autovalidateMode: autoValidateMode,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          style: Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            prefixText: prefixText,
            prefixStyle: prefixTextStyle,
            prefix: prefix,
            prefixIconConstraints: BoxConstraints(minWidth: 40, maxWidth: 40, minHeight: prefixIconSize ?? kMinInteractiveDimension),
            errorText: errorText,
            errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: errorRed,
                fontWeight: FontWeight.bold
            ),
            suffixIconConstraints: BoxConstraints(minWidth: suffixIconSize ?? 40, maxWidth: suffixIconSize ?? 40, minHeight: suffixIconSize ?? kMinInteractiveDimension),
            suffixIcon: suffixIcon != null ? InkWell(
              splashColor: Colors.transparent,
              customBorder: CircleBorder(),
              onTap: suffixOnPressed,
              child: suffixIcon,
            ) : SizedBox(),
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: primaryGrey,
              fontSize: 14
            ),
            fillColor: primaryWhite,
            contentPadding: contentPadding,
          ),
          textAlign: textAlign,
        ),
      ],
    );
  }
}