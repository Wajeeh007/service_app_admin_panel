import 'package:flutter/material.dart';

import 'custom_text_form_field.dart';

class SearchFieldAndButton extends StatelessWidget {
  const SearchFieldAndButton({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint,
    this.fieldWidth,
  });

  final TextEditingController controller;
  final String? hint;
  final double? fieldWidth;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 10,
      children: [
        SizedBox(
          width: fieldWidth,
          child: CustomTextFormField(
            onChanged: onChanged,
            suffixIconSize: 10,
                autoValidateMode: AutovalidateMode.disabled,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 22,
                ),
                controller: controller,
                hint: hint,
              ),
          ),
      ],
    );
  }
}