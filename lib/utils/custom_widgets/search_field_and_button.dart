import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../validators.dart';
import 'custom_material_button.dart';
import 'custom_text_form_field.dart';

class SearchFieldAndButton extends StatelessWidget {
  SearchFieldAndButton({
    super.key,
    required this.controller,
    required this.formKey,
    this.hint,
    this.fieldWidth,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String? hint;
  final double? fieldWidth;

  final RxBool changeValidateMode = false.obs;

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 10,
      children: [
        SizedBox(
          width: fieldWidth,
          child: Form(
              key: formKey,
              child: Obx(() => CustomTextFormField(
                suffixIconSize: 10,
                  onChanged: (value) {
                    if(value == '' || value.isEmpty) {
                      changeValidateMode.value = false;
                    } else {
                      changeValidateMode.value = true;
                    }
                  },
                    autoValidateMode: changeValidateMode.value ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 22,
                    ),
                    controller: controller,
                    validator: (value) => Validators.validateEmptyField(value),
                    hint: hint,
                  ),
              ),
              )
          ),
        CustomMaterialButton(
          onPressed: () {
            if(formKey.currentState!.validate()) {

            }
          },
          text: lang_key.search.tr,
          width: 100,
        )
      ],
    );
  }
}