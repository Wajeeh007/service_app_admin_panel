import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../validators.dart';
import 'custom_material_button.dart';
import 'custom_text_form_field.dart';

class SearchFieldAndButton extends StatelessWidget {
  const SearchFieldAndButton({
    super.key,
    required this.controller,
    required this.formKey,
    this.hint
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 10,
      children: [
        SizedBox(
          width: 200,
          child: Form(
              key: formKey,
              child: CustomTextFormField(
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 22,
                ),
                controller: controller,
                validator: (value) => Validators.validateEmptyField(value),
                hint: hint,
              )
          ),
        ),
        CustomMaterialButton(
          onPressed: () {},
          text: lang_key.search.tr,
          width: 100,
        )
      ],
    );
  }
}